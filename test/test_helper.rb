$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest_lucid'

class MinitestLucidTest < Minitest::Test
  def do_test(klass, expected, actual)
    names = names_for_class(klass)
    dir_path = File.join(File.dirname(__FILE__), names[:dir_name])
    Dir.chdir(dir_path) do
      msg = "#{expected.class} and #{actual.class}"
      x = assert_raises (Minitest::Assertion) do
        assert_equal(expected, actual, msg)
      end
      name = klass.name.downcase
      subname = 'sub' + name
      exp_name = expected.class == klass ? names[:name] : names[:subname]
      act_name = actual.class == klass ? names[:name] : names[:subname]
      exp_file_path = "expected/#{exp_name}.#{act_name}.html"
      file_path = x.message.split(' ').last
      act_file_path = "actual/#{exp_name}.#{act_name}.html"
      Minitest::Assertions.condition_file(file_path, act_file_path)
      exp_lines = File.readlines(exp_file_path)
      act_lines = File.readlines(act_file_path)
      diffs = Diff::LCS.diff(exp_lines, act_lines)
      assert_empty(diffs)
    end
  end

  def names_for_class(klass)
    {
      Hash => {
        :dir_name => 'hash',
        :name => 'hash',
        :subname => 'subhash',
      },
      Set => {
        :dir_name => 'set',
        :name => 'set',
        :subname => 'subset',
      },
      Struct::MyStruct => {
        :dir_name => 'struct',
        :name => 'struct',
        :subname => 'substruct',
      },
    }[klass]
  end

end