# Minitest Lucid

Use ```minitest_lucid``` to improve assertion messages from ```minitest```.

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



