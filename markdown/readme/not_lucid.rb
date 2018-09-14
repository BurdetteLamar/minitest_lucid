require 'minitest/autorun'

class MyTest < Minitest::Test

  def test_foo
    expected = {:a => 0, :b => 1}
    actual = {}
    assert_equal(expected, actual)
  end
end
