# Minitest Lucid

[![Gem](https://img.shields.io/gem/v/minitest_lucid.svg?style=flat)](http://rubygems.org/gems/minitest_lucid "View this project in Rubygems")

When you use gem ```miiitest```, a failed assertion for a large or complex object can be difficult to understand.

Using method ```make_my_diffs_pretty!``` (it's part of ```minitest```) can sometimes help, but sometimes not enough.

Use gem ```minitest_lucid``` to improve assertion messages from ```minitest```.

## Usage

To use ```minitest_lucid```, install the gem and then in your tests,

```ruby
require 'minitest_lucid'
```

instead of

```ruby
require 'minitest/autorun'
```

No other code change is required.

For example, change this test

```ruby
require 'minitest/autorun'

class MyTest < Minitest::Test
  def test_foo
    expected = {:a => 0, :b => 1}
    actual = {}
    assert_equal(expected, actual)
  end
end
```

to this

```ruby
require 'minitest_lucid'

class MyTest < Minitest::Test
  def test_foo
    expected = {:a => 0, :b => 1}
    actual = {}
    assert_equal(expected, actual)
  end
end
```

See example outputs below.

## Supported Classes

For supported classes, method ```assert_equal``` gets elucidated handling.

For other classes and assertion methods, the original assertion behaviors are unchanged.

The supported classes:

- [Hash](#hash)
- [Set](#set)
- [Struct](#struct)

The examples below show:

- The message from a normal failed assertion.
- The message as modified by the use of ```make_my_diffs_pretty!``` (which is part of ```minitest``` itself).
- The message as modified by the use of ```minitest_lucid```.

@[:markdown](hash/template.md)

@[:markdown](set/template.md)

@[:markdown](struct/template.md)



