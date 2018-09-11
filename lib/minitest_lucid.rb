require 'minitest/autorun'
require 'diff/lcs'
require 'set'

require 'minitest_lucid/version'

module Minitest

  module Assertions

    alias :old_assert_equal :assert_equal

    def assert_equal(expected, actual, msg=nil)
      begin
        old_assert_equal(expected, actual, msg)
      rescue Minitest::Assertion => x
        elucidate(x, expected, actual, msg)
      end
    end

    METHOD_FOR_CLASS = {
        Struct => :elucidate_struct,
        Hash => :elucidate_hash,
        Set => :elucidate_set,
    }
    ELUCIDATABLE_CLASSES = METHOD_FOR_CLASS.keys

    def elucidate(exception, expected, actual, msg)
      elucidation_method = nil
      # Determine whether one of the objects is directly elucidatable.
      if ELUCIDATABLE_CLASSES.include?(expected.class)
        if actual.kind_of?(expected.class)
          elucidation_method = METHOD_FOR_CLASS.fetch(expected.class)
        end
      elsif ELUCIDATABLE_CLASSES.include?(actual.class)
        if expected.kind_of?(actual.class)
          elucidation_method = METHOD_FOR_CLASS.fetch(actual.class)
        end
      end
      unless elucidation_method
        # Poll with kind_of?.
        METHOD_FOR_CLASS.each_pair do |klass, method|
          next unless expected.kind_of?(klass)
          next unless actual.kind_of?(klass)
          elucidation_method = method
          break
        end
      end
      if elucidation_method
        lines = ['']
        lines.push("Message:  #{msg}") if msg
        lines.push("Expected class:  #{expected.class}")
        lines.push("Actual class:  #{actual.class}")
        send(elucidation_method, exception, expected, actual, lines)
        lines.push('')
        message = lines.join("\n")
        new_exception = exception.exception(message)
        new_exception.set_backtrace(exception.backtrace)
        raise new_exception
      else
        raise
      end
    end

    def elucidate_array(exception, expected, actual, lines)
      sdiff = Diff::LCS.sdiff(expected, actual)
      changes = {}
      statuses = {
          '!' => 'changed',
          '+' => 'unexpected',
          '-' => 'missing',
          '=' => 'unchanged'
      }
      sdiff.each_with_index do |change, i|
        status = statuses.fetch(change.action)
        key = "change_#{i}"
        change_data = {
            :status => status,
            :old => "pos=#{change.old_position} ele=#{change.old_element}",
            :new => "pos=#{change.new_position} ele=#{change.new_element}",
        }
        changes.store(key, change_data)
      end
      p changes
      lines.push('elucidation = {')
      changes.each_pair do |category, change_data|
        p category
        status = change_data.delete(:status)
        change_data.delete(:old) if status == 'unexpected'
        change_data.delete(:new) if status == 'missing'
        change_data.each_pair do |k, v|
          p [k, v]
        end
      end
      lines.push('}')
      # put_element('analysis', attrs) do
      #   changes.each_pair do |key, change_data|
      #     status = change_data.delete(:status)
      #     change_data.delete(:old) if status == 'unexpected'
      #     change_data.delete(:new) if status == 'missing'
      #     put_element(status) do
      #       change_data.each_pair do |k, v|
      #         put_element(k.to_s, v)
      #       end
      #     end
      #   end
      # end
    end

    def elucidate_hash(exception, expected, actual, lines)
      expected_keys = expected.keys
      actual_keys = actual.keys
      keys = Set.new(expected_keys + actual_keys)
      h = {
          :missing_pairs => {},
          :unexpected_pairs => {},
          :changed_values => {},
          :ok_pairs => {},
      }
      keys.each do |key|
        expected_value = expected[key]
        actual_value = actual[key]
        case
          when expected_value && actual_value
            if expected_value == actual_value
              h[:ok_pairs].store(key, expected_value)
            else
              h[:changed_values].store(key, [expected_value, actual_value])
            end
          when expected_value
            h[:missing_pairs].store(key, expected_value)
          when actual_value
            h[:unexpected_pairs].store(key, actual_value)
          else
            fail [expected_value, actual_value].inspect
        end
      end
      lines.push('elucidation = {')
      h.each_pair do |category, items|
        lines.push("  #{pretty(category)} => {")
        items.each_pair do |key, value|
          if value.instance_of?(Array)
            expected, actual = *value
            lines.push("    #{pretty(key)} => {")
            lines.push("      :expected => #{pretty(expected)},")
            lines.push("      :got      => #{pretty(actual)},")
            lines.push('    },')
          else
            lines.push("    #{pretty(key)} => #{pretty(value)},")
          end
        end
        lines.push('  },')
      end
      lines.push('}')
    end

    def elucidate_set(exception, expected, actual, lines)
      result = {
          :missing => expected.difference(actual),
          :unexpected => actual.difference(expected),
          :ok => expected.intersection(actual),
      }
      lines.push('elucidation = {')
      result.each_pair do |category, items|
        lines.push("  #{pretty(category)} => {")
        items.each do |member|
          lines.push("    #{pretty(member)},")
        end
        lines.push('  },')
      end
      lines.push('}')
    end

    def elucidate_struct(exception, expected, actual, lines)
      expected_members = expected.members
      actual_members = actual.members
      members = Set.new(expected_members + actual_members)
      h = {
          :changed_values => {},
          :ok_values => {},
      }
      members.each do |member|
        expected_value = expected[member]
        actual_value = actual[member]
        if expected_value == actual_value
          h[:ok_values].store(member, expected_value)
        else
          h[:changed_values].store(member, [expected_value, actual_value])
        end
      end
      lines.push('elucidation = {')
      h.each_pair do |category, items|
        lines.push("  #{pretty(category)} => {")
        items.each_pair do |member, value|
          if value.instance_of?(Array)
            expected, actual = *value
            lines.push("    #{pretty(member)} => {")
            lines.push("      :expected => #{pretty(expected)},")
            lines.push("      :got      => #{pretty(actual)},")
            lines.push('    },')
          else
            lines.push("    #{pretty(member)} => #{pretty(value)},")
          end
        end
        lines.push('  },')
      end
      lines.push('}')
    end

    def pretty(arg)
      case
        when arg.kind_of?(Symbol)
          ":#{arg}"
        when arg.kind_of?(String)
          "'#{arg}'"
        when arg.kind_of?(Numeric)
          arg
        else
          arg.inspect
      end
    end

  end
  
end
