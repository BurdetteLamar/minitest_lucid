require 'minitest/autorun'
require 'diff/lcs'
require 'rexml/document'

require 'minitest_lucid/lucid_set'

module Minitest

  module Assertions

    alias old_assert_equal assert_equal

    def assert_equal(expected, actual, msg=nil)
      begin
        old_assert_equal(expected, actual, msg)
      rescue Minitest::Assertion => x
        elucidation_class  = get_class(expected, actual)
        return unless elucidation_class
        elucidation_class.elucidate(x, expected, actual)
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
        return Object.const_get("#{self.class.name}::Lucid#{klass.name}")
      end
      nil
    end

    def self.elucidate(exception, expected, actual)
      doc = REXML::Document.new
      html_ele = doc.add_element('html')
      head_ele = html_ele.add_element('head')
      style_ele = head_ele.add_element('style')
      style_ele.text = STYLES
      @body_ele = html_ele.add_element('body')
      h1_ele = @body_ele.add_element('h1')
      h1_ele.text = 'Elucidation'
      @toc_ul_ele = @body_ele.add_element('ul')
      Minitest::Assertions.elucidate_expected_items(expected)
      Minitest::Assertions.elucidate_actual_items(actual)
      yield
      Minitest::Assertions.elucidate_exception(exception)
      Minitest::Assertions.elucidate_backtrace(exception.backtrace)
      output = ""
      doc.write(:output => output, :indent => 0)
      new_message = output
      new_exception = exception.exception(new_message)
      new_exception.set_backtrace(exception.backtrace)
      raise new_exception
    end

    def self.toc_link(id)
      li_ele = REXML::Element.new('li')
      a_ele = li_ele.add_element('a')
      a_ele.attributes['href'] = "##{id}"
      a_ele.text = id.capitalize
      li_ele
    end

    def self.section_header(level, id, header_text)
      h_ele = REXML::Element.new("h#{level}")
      h_ele.attributes['id'] = id
      h_ele.text = header_text
      h_ele
    end

    def self.items_table(class_names, items)
      table_ele = REXML::Element.new('table')
      table_ele.attributes['border'] = '1'
      # Header row.
      tr_ele = table_ele.add_element('tr')
      th_ele = tr_ele.add_element('th')
      th_ele.text = 'Class'
      th_ele = tr_ele.add_element('th')
      th_ele.text = 'Inspect Value'
      # Data rows.
      items.each do |item|
        tr_ele = table_ele.add_element('tr')
        td_ele = tr_ele.add_element('td')
        td_ele.attributes['class'] = class_names
        td_ele.text = item.class.name
        td_ele = tr_ele.add_element('td')
        td_ele.attributes['class'] = class_names
        td_ele.text = item.inspect
      end
      table_ele
    end

    def self.elucidate_exception(exception)
      id = 'exception'
      @toc_ul_ele.add_element(self.toc_link(id))
      @body_ele.add_element(self.section_header(3, id, 'Exception'))
      table_ele = @body_ele.add_element('table')
      table_ele.attributes['border'] = '1'
      tr_ele = table_ele.add_element('tr')
      th_ele = tr_ele.add_element('th')
      th_ele.text = 'Class'
      td_ele = tr_ele.add_element('td')
      td_ele.text = exception.class.name
      tr_ele = table_ele.add_element('tr')
      th_ele = tr_ele.add_element('th')
      th_ele.text = 'Message'
      td_ele = tr_ele.add_element('td')
      td_ele.text = exception.message
      tr_ele = table_ele.add_element('tr')
      th_ele = tr_ele.add_element('th')
      th_ele.text = 'Backtrace'
      td_ele = tr_ele.add_element('td')
      gem_dir_path = File.dirname(`gem which minitest`)
      backtrace = exception.backtrace.map { |x| x.sub(gem_dir_path, '<GEM_DIR>')}
      home_dir_path = ENV['HOME'].gsub('\\', '/')
      backtrace = backtrace.map { |x| x.sub(home_dir_path, '<HOME_DIR>')}
      td_ele.add_element(self.items_table('data', backtrace))
    end

    def self.elucidate_backtrace(backtrace)
      id = 'backtrace'
      @toc_ul_ele.add_element(self.toc_link(id))
      @body_ele.add_element(self.section_header(3, id, 'Backtrace (Filtered)'))
      gem_dir_path = File.dirname(`gem which minitest`)
      backtrace = backtrace.map { |x| x.sub(gem_dir_path, '<GEM_DIR>')}
      while backtrace.last.start_with?('<GEM_DIR>')
        backtrace.pop
      end
      until backtrace.empty? do
        line = backtrace.shift
        break if line.match(/minitest_lucid\.rb/)
      end
      home_dir_path = ENV['HOME'].gsub('\\', '/')
      backtrace = backtrace.map { |x| x.sub(home_dir_path, '<HOME_DIR>')}
      @body_ele.add_element(self.items_table('data', backtrace))
    end

    def self.elucidate_items(class_names, id, header_text, items)
      @toc_ul_ele.add_element(self.toc_link(id))
      @body_ele.add_element(self.section_header(3, id, header_text))
      @body_ele.add_element(self.items_table(class_names, items)) unless items.empty?
    end

    def self.elucidate_expected_items(expected)
      id = 'Expected'
      header_text = "#{id}:  class=#{expected.class} size=#{expected.size}"
      Minitest::Assertions.elucidate_items('data', id, header_text, expected)
    end

    def self.elucidate_actual_items(actual)
      id = 'Got'
      header_text = "#{id}:  class=#{actual.class} size=#{actual.size}"
      Minitest::Assertions.elucidate_items('data', id, header_text, actual)
    end

    def self.elucidate_missing_items(missing)
      id = 'Missing'
      header_text = "#{id} items: #{missing.size}"
      Minitest::Assertions.elucidate_items('bad data', id, header_text, missing)
    end

    def self.elucidate_unexpected_items(unexpected)
      id = 'Unexpected'
      header_text = "#{id} items: #{unexpected.size}"
      Minitest::Assertions.elucidate_items('bad data', id, header_text, unexpected)
    end

    def self.elucidate_ok_items(ok)
      id = 'Ok'
      header_text = "#{id} items: #{ok.size}"
      Minitest::Assertions.elucidate_items('good data', id, header_text, ok)
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

  end

end
