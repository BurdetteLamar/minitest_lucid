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

@[ruby](not_lucid.rb)

to this

@[ruby](lucid.rb)

See example outputs below.

## Supported Classes

For supported classes, method ```assert_equal``` gets elucidated handling.

For other classes and assertion methods, the original assertion behaviors are unchanged.

The supported classes:

- [Hash](#hash)
- [Set](#set)
- [Struct](#struct)

@[:markdown](hash/template.md)

@[:markdown](set/template.md)

@[:markdown](struct/template.md)



