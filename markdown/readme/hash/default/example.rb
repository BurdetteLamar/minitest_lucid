require 'minitest/autorun'

class Example < Minitest::Test

  def test_assert_equal
    begin
      require_relative 'data'
      assert_equal(expected, actual)
    rescue Minitest::Assertion => x
      File.open('default.txt', 'w') do |file|
        file.write(x.message)
      end
    end
    begin
      require_relative 'data'
      Minitest::Test.make_my_diffs_pretty!
      assert_equal(expected, actual)
    rescue Minitest::Assertion => x
      File.open('pretty.txt', 'w') do |file|
        file.write(x.message)
      end
    end
    begin
      require_relative 'data'
      require 'minitest_lucid'
      assert_equal(expected, actual)
    rescue Minitest::Assertion => x
      File.open('lucid.txt', 'w') do |file|
        file.write(x.message)
      end
    end
  end

end


