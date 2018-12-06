require 'minitest/autorun'
require 'diff/lcs'
require 'rexml/document'
require 'set'
require 'tmpdir'

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
        Hash => :elucidate_hash,
        Set => :elucidate_set,
        Struct => :elucidate_struct,
        # Array => :elucidate_array,
    }
    ELUCIDATABLE_CLASSES = METHOD_FOR_CLASS.keys

    # Lookup objects in hash.
    def lookup(one_object, other_object)
      if ELUCIDATABLE_CLASSES.include?(one_object.class)
        if other_object.kind_of?(one_object.class)
          return METHOD_FOR_CLASS.fetch(one_object.class)
        end
      end
      nil
    end

    # Poll with kind_of?.
    def poll(expected, actual)
      METHOD_FOR_CLASS.each_pair do |klass, method|
        next unless expected.kind_of?(klass)
        next unless actual.kind_of?(klass)
        return method
      end
      nil
    end

    def elucidate(exception, expected, actual, msg)
      elucidation_method  =
          lookup(expected, actual) ||
          lookup(actual, expected) ||
          poll(expected, actual)
      if elucidation_method
        lines = ['']
        lines.push('{')
        lines.push("  :message => '#{msg}',") if msg
        send(elucidation_method, exception, expected, actual, lines)
        lines.push('}')
        lines.push('')
        message = lines.join("\n")
        new_exception = exception.exception(message)
        new_exception.set_backtrace(exception.backtrace)
        raise new_exception
      else
        raise
      end
    end

    # Notes for future elucidation of arrays.
    # Element-by-element comparison.
    # Diff-LCS comparison.
    # Missing elements: expected - actual.
    # Unexpected elements: actual - expected.
    # Common elements: actual & expected.
    # All elements: actual | expected.

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

    class Html

      attr_accessor :doc, :head, :body, :toc_list

      GOOD_STYLE = 'good'
      NEUTRAL_STYLE = 'neutral'
      BAD_STYLE = 'bad'
      DATA_STYLE = 'data'
      STATUS_STYLE = 'status'
      CLASS_STYLE = 'class'
      NAME_STYLE = 'name'

      def initialize
        self.doc = REXML::Document.new
        html = doc.add_element('html')
        head = html.add_element('head')
        style = head.add_element('style')
        style.text = <<EOT
.#{GOOD_STYLE} {color: rgb(0,97,0) ; background-color: rgb(198,239,206) }
.#{NEUTRAL_STYLE} { color: rgb(0,0,0) ; background-color: rgb(200,200,200) }
.#{BAD_STYLE} { color: rgb(156,0,6); background-color: rgb(255,199,206) }
.#{DATA_STYLE} { font-family: Courier, Courier, serif }
.#{STATUS_STYLE} { text-align: center; }
.#{CLASS_STYLE} { text-align: center; font-family: Courier, Courier, serif }
.#{NAME_STYLE} { text-align: center; font-family: Courier, Courier, serif }
EOT
        self.body = html.add_element('body')
        body.add_element('h1').text = 'Comparison'
        self.toc_list = body.add_element('ul')
        self.head = head
      end

      def write(test)
        temp_dir_path = Dir.tmpdir
        file_path = File.join(
            temp_dir_path,
            'minitest_lucid_set.html'
        )
        p test.name
        File.open(file_path, 'w') do |file|
          doc.write(file, 2)
        end
        system("start #{file_path}")

      end

      def set_status_new_table(label, items)
        title = "#{label}: Class=#{items.class}, Size=#{items.size}"
        h = new_h2(body, title, {:id => label})
        li = new_li(toc_list)
        new_a(li, h.text, {:href => "##{label}"})
        table = new_table(body)
        tr = new_tr(table, {:class => Html::NEUTRAL_STYLE})
        new_ths(tr, Html::STATUS_STYLE, 'Class', 'Inspection')
        table
      end

      def set_status_tds(tr, status, item)
        new_td(tr, status, {:class => Html::STATUS_STYLE})
        new_td(tr, item.class, {:class => Html::CLASS_STYLE})
        new_td(tr, item.inspect, {:class => Html::DATA_STYLE})
      end

      def struct_status_new_table(label, items)
        title = "#{label}: Class=#{items.class}, Size=#{items.size}"
        h = new_h2(body, title, {:id => label})
        li = new_li(toc_list)
        new_a(li, h.text, {:href => "##{label}"})
        table = new_table(body)
        tr = new_tr(table, {:class => Html::NEUTRAL_STYLE})
        new_ths(tr, Html::STATUS_STYLE, 'Name', 'Values')
        table
      end

      def struct_status_tds(tr, status, name, values)
        addl_class = status == 'Ok' ? Html::GOOD_STYLE : Html::BAD_STYLE
        data_class = "data #{addl_class}"
        name_class = "name #{addl_class}"
        class_class = "class #{addl_class}"
        status_class = "status #{addl_class}"
        new_td(tr, status, {:class => status_class})
        new_td(tr, name, {:class => name_class})
        # Values table, expected and actual
        table = new_table(new_td(tr, nil), {:width => '100%'})
        # Header row.
        tr = new_tr(table, {:class => Html::NEUTRAL_STYLE})
        new_ths(tr, '', 'Class', 'Value')
        # Expected value.
        value = values[:expected]
        tr = new_tr(table)
        new_th(tr, 'Expected', {:class => Html::NEUTRAL_STYLE})
        new_td(tr, value.class, {:class => class_class})
        new_td(tr, value.inspect, {:class => data_class})
        # Actual value.
        value = values[:actual]
        tr = new_tr(table)
        new_th(tr, 'Actual', {:class => Html::NEUTRAL_STYLE})
        new_td(tr, value.class, {:class => class_class})
        new_td(tr, value.inspect, {:class => data_class})
      end

      def new_element(name, parent, attributes = {})
        ele = REXML::Element.new(name, parent)
        attributes.each_pair do |k, v|
          ele.attributes[k.to_s] = v
        end
        ele
      end

      def new_a(parent, text, attributes = {})
        ele = new_element('a', parent, attributes)
        ele.text = text
        ele
      end

      def new_h2(parent, text, attributes = {})
        ele = new_element('h2', parent, attributes)
        ele.text = text
        ele
      end

      def new_li(parent, attributes = {})
        new_element('li', parent, attributes)
      end

      def new_table(parent, attributes = {})
        new_element('table', parent, attributes)
      end

      def new_tr(parent, attributes = {})
        new_element('tr', parent, attributes)
      end

      def new_th(parent, text, attributes = {})
        ele = new_element('th', parent, attributes)
        ele.text = text
        ele
      end

      def new_ths(parent, *texts)
        eles = []
        texts.each do |text|
          eles.push(new_th(parent, text))
        end
        eles
      end

      def new_td(parent, text, attributes = {})
        ele = new_element('td', parent, attributes)
        ele.text = text
        ele
      end

    end

    def elucidate_set(exception, expected, actual, lines)

      result = {
          :missing => expected - actual,
          :unexpected => actual - expected,
          :ok => expected & actual,
      }

      html = Html.new

      table = html.set_status_new_table('Expected', expected)
      expected.each do |item, i|
        status = result[:missing].include?(item) ? 'Missing' : 'Ok'
        tr = html.new_tr(table, {:class => status == 'Ok' ? Html::GOOD_STYLE : Html::BAD_STYLE})
        html.set_status_tds(tr, status, item)
      end

      table = html.set_status_new_table('Actual', actual)
      actual.each do |item|
        status = result[:unexpected].include?(item) ? 'Unexpected' : 'Ok'
        tr = html.new_tr(table, {:class => status == 'Ok' ? Html::GOOD_STYLE : Html::BAD_STYLE})
        html.set_status_tds(tr, status, item)
      end

      table = html.set_status_new_table('Missing (Expected - Actual)', result[:missing])
      result[:missing].each do |item|
        status = 'Missing'
        tr = html.new_tr(table, {:class => Html::BAD_STYLE})
        html.set_status_tds(tr, status, item)
      end

      table = html.set_status_new_table('Unexpected (Actual - Expected)', result[:unexpected])
      result[:unexpected].each do |item|
        status = 'Unexpected'
        tr = html.new_tr(table, {:class => Html::BAD_STYLE})
        html.set_status_tds(tr, status, item)
      end

      table = html.set_status_new_table('Ok (Expected & Actual)', result[:ok])
      result[:ok].each do |item|
        status = 'Ok'
        tr = html.new_tr(table, {:class => Html::GOOD_STYLE})
        html.set_status_tds(tr, status, item)
      end

      html.write(self)

      lines.push('  :expected => {')
      lines.push("    :class => #{expected.class},")
      lines.push("    :size => #{expected.size},")
      lines.push('  },')
      lines.push('  :actual => {')
      lines.push("    :class => #{actual.class},")
      lines.push("    :size => #{actual.size},")
      lines.push('  },')
      result.each_pair do |category, items|
        lines.push("  #{pretty(category)} => [")
        items.each do |member|
          lines.push("    #{pretty(member)},")
        end
        lines.push('  ],')
      end
    end

    def elucidate_struct(exception, expected, actual, lines)
      categories = {
          :all_values => {},
          :changed_values => {},
          :ok_values => {},
      }
      expected.members.each do |member|
        expected_value = expected[member]
        actual_value = actual[member]
        values  = {
            :expected => expected_value,
            :actual => actual_value,
        }
        categories[:all_values].store(member, values)
        if expected_value == actual_value
          categories[:ok_values].store(member, values)
        else
          categories[:changed_values].store(member, values)
        end
      end

      html = Html.new

      table = html.struct_status_new_table('All', expected)
      expected.members.each do |member|
        values = categories[:all_values][member]
        status = categories[:ok_values].keys.include?(member) ? 'Ok' : 'Changed'
        tr = html.new_tr(table)
        html.struct_status_tds(tr, status, member, values)
      end

      table = html.struct_status_new_table('Changed', categories[:changed_values])
      categories[:changed_values].each_pair do |member, values|
        status = 'Changed'
        tr = html.new_tr(table)
        html.struct_status_tds(tr, status, member, values)
      end

      table = html.struct_status_new_table('Ok', categories[:ok_values])
      categories[:ok_values].each_pair do |member, values|
        status = 'Ok'
        tr = html.new_tr(table)
        html.struct_status_tds(tr, status, member, values)
      end

      html.write(self)

      lines.push('  :expected => {')
      lines.push("    :class => #{expected.class},")
      lines.push("    :size => #{expected.size},")
      lines.push('  },')
      lines.push('  :actual => {')
      lines.push("    :class => #{actual.class},")
      lines.push("    :size => #{actual.size},")
      lines.push('  },')
      lines.push('  :elucidation => {')
      categories.each_pair do |category, items|
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

  end

end
