require 'minitest/autorun'
require 'diff/lcs'
require 'set'
require 'nokogiri'

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

    ELUCIDATABLE_CLASSES = [
      Array,
      Hash,
      Set,
      Struct,
    ]
    STYLES = <<EOT
        
    .good {color: rgb(0,97,0) ; background-color: rgb(198,239,206) }
    .neutral { color: rgb(156,101,0) ; background-color: rgb(255,236,156) }
    .bad { color: rgb(156,0,6); background-color: rgb(255,199,206) }
    .data { font-family: Courier New, monospace }
    .data_changed { font-family: Courier New, monospace; font-weight: bold; font-style: italic }
EOT

    # Poll with kind_of?.
    def get_class(expected, actual)
      ELUCIDATABLE_CLASSES.each do |klass|
        next unless expected.kind_of?(klass)
        next unless actual.kind_of?(klass)
        return Object.const_get("#{self.class.name}::#{klass.name}Elucidation")
      end
      nil
    end

    def elucidate(exception, expected, actual, msg)
      elucidation_class  = get_class(expected, actual)
      if elucidation_class
        builder = Nokogiri::HTML::Builder.new do |doc|
          doc.html do
            doc.head do
              doc.style do
                doc.text(STYLES)
              end
            end
            doc.body do
              doc.h1 do
                doc.text('Elucidation')
              end
              elucidation_class.elucidate(doc, exception, expected, actual)
            end
          end
          new_message = doc.to_html
          new_exception = exception.exception(new_message)
          new_exception.set_backtrace(exception.backtrace)
          raise new_exception
        end
      end
    end

    def self.elucidate_items(doc, classes, id, header_text, items)
      doc.h2(:id => id) do
        doc.text(header_text)
      end
      unless items.empty?
        doc.table(:border => 1) do
          doc.tr do
            doc.th do
              doc.text('Class')
            end
            doc.th do
              doc.text('Inspect Value')
            end
          end
          items.each do |item|
            doc.tr do
              doc.td(:class => classes) do
                doc.text(item.class.name)
              end
              doc.td(:class => classes) do
                doc.text(item.inspect)
              end
            end
          end
        end
      end

    end

    def self.elucidate_expected_items(doc, expected)
      id = 'Expected'
      header_text = "#{id}:  class=#{expected.class} size=#{expected.size}"
      Minitest::Assertions.elucidate_items(doc, 'data', id, header_text, expected)
    end

    def self.elucidate_actual_items(doc, actual)
      id = 'Got'
      header_text = "#{id}:  class=#{actual.class} size=#{actual.size}"
      Minitest::Assertions.elucidate_items(doc, 'data', id, header_text, actual)
    end

    def self.elucidate_missing_items(doc, missing)
      id = 'Missing'
      header_text = "#{id} items: #{missing.size}"
      Minitest::Assertions.elucidate_items(doc, 'bad data', id, header_text, missing)
    end

    def self.elucidate_unexpected_items(doc, unexpected)
      id = 'Unexpected'
      header_text = "#{id} items: #{unexpected.size}"
      Minitest::Assertions.elucidate_items(doc, 'bad data', id, header_text, unexpected)
    end

    def self.elucidate_ok_items(doc, ok)
      id = 'Ok'
      header_text = "#{id} items: #{ok.size}"
      Minitest::Assertions.elucidate_items(doc, 'good data', id, header_text, ok)
    end

    # Element-by-element comparison.
    #     Diff-LCS comparison.
    #     Missing elements: expected - actual.
    #         Unexpected elements: actual - expected.
    #     Common elements: actual & expected.
    #     All elements: actual | expected.


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
            :"old_index_#{change.old_position}" => change.old_element.inspect,
            :"new_index_#{change.new_position}" => change.new_element.inspect,
        }
        changes.store(key, change_data)
      end
      lines.push('elucidation = [')
      changes.each_pair do |category, change_data|
        status = change_data.delete(:status)
        if status == 'unexpected'
          change_data.delete_if {|key, value| key.match(/old/) }
        end
        if status == 'missing'
          change_data.delete_if {|key, value| key.match(/new/) }
        end
        lines.push('  {')
        lines.push("  :status => :#{status},")
        change_data.each_pair do |k, v|
          lines.push("  :#{k} => #{v},")
        end
        lines.push('  },')
      end
      lines.push(']')
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
      lines.push('  :expected => {')
      lines.push("    :class => #{expected.class},")
      lines.push("    :size => #{expected.size},")
      lines.push('  },')
      lines.push('  :actual => {')
      lines.push("    :class => #{actual.class},")
      lines.push("    :size => #{actual.size},")
      lines.push('  },')
      lines.push('  :elucidation => {')
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
      lines.push('  }')
    end

    class SetElucidation

      def self.elucidate(doc, exception, expected, actual)
        missing = expected - actual
        unexpected = actual - expected
        ok = expected & actual
        doc.ul do
          %w/Expected Got Missing Unexpected Ok/.each do |word|
            doc.li do
              doc.a(:href => "##{word}") do
                doc.text(word)
              end
            end
          end
        end
        Minitest::Assertions.elucidate_expected_items(doc, expected)
        Minitest::Assertions.elucidate_actual_items(doc, actual)
        Minitest::Assertions.elucidate_missing_items(doc, missing)
        Minitest::Assertions.elucidate_unexpected_items(doc, unexpected)
        Minitest::Assertions.elucidate_ok_items(doc, ok)
      end

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
      lines.push('  :expected => {')
      lines.push("    :class => #{expected.class},")
      lines.push("    :size => #{expected.size},")
      lines.push('  },')
      lines.push('  :actual => {')
      lines.push("    :class => #{actual.class},")
      lines.push("    :size => #{actual.size},")
      lines.push('  },')
      lines.push('  :elucidation => {')
      h.each_pair do |category, items|
        lines.push("    #{pretty(category)} => {")
        items.each_pair do |member, value|
          if value.instance_of?(Array)
            expected, actual = *value
            lines.push("      #{pretty(member)} => {")
            lines.push("        :expected => #{pretty(expected)},")
            lines.push("        :got      => #{pretty(actual)},")
            lines.push('      },')
          else
            lines.push("      #{pretty(member)} => #{pretty(value)},")
          end
        end
        lines.push('    },')
      end
      lines.push('  }')
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

    def h2_ele(parent)
      h2_ele = parent.add_element('h2')
    end

    def table_ele(parent, attributes = {})
      ele = REXML::Element.new('table', parent)
      ele.attributes['border'] = 0
      attributes.each_pair do |k, v|
        ele.attributes[k.to_s] = v
      end
      ele
    end

    def tr_ele(parent)
      parent << REXML::Element.new('tr')
    end

    def th_ele(parent, text)
      ele = REXML::Element.new('th')
      parent << ele
      ele.text = text
      ele
    end

    def th_eles(parent, *texts)
      texts.each do |text|
        th_ele(parent, text)
      end
    end

    def td_ele(parent, text)
      ele = REXML::Element.new('td')
      parent << ele
      ele.text = text
      ele
    end

    def td_eles(parent, *texts)
      eles = []
      texts.each do |text|
        eles << td_ele(parent, text)
      end
      eles
    end

  end

end
