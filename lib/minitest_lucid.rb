require 'minitest/autorun'

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

    def elucidate(exception, expected, actual, msg)
      elucidation_method = nil
      {
          [:each_pair] => :elucidate_each_pair,
      }.each_pair do |discriminant_methods, method|
        discriminant_methods.each do |discriminant_method|
          next unless expected.respond_to?(discriminant_method)
          next unless actual.respond_to?(discriminant_method)
          elucidation_method = method
          break
        end
        break if elucidation_method
      end
      if elucidation_method
        send(elucidation_method, exception, expected, actual, msg)
      else
        raise
      end
    end

    def elucidate_each_pair(exception, expected, actual, msg)
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
        end
      end
      lines = ['']
      lines.push("Message:  #{msg}") if msg
      lines.push('elucidation = {')
      h.each_pair do |category, items|
        lines.push("    #{pretty(category)} => {")
        items.each_pair do |key, value|
          if value.instance_of?(Array)
            expected, actual = *value
            lines.push("      #{pretty(key)} => {")
            lines.push("        :expected => #{pretty(expected)},")
            lines.push("        :got      => #{pretty(actual)},")
            lines.push('      },')
          else
            lines.push("      #{pretty(key)} => #{pretty(value)},")
          end
        end
        lines.push('    },')
      end
      lines.push('}')
      lines.push('')
      message = lines.join("\n")
      new_exception = exception.exception(message)
      new_exception.set_backtrace(exception.backtrace)
      raise new_exception
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
