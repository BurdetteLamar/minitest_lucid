#### assert_equal

Here are structs, expected and actual, to be compared.

@[ruby](data.rb)

The default ```Minitest::Assertion``` message:

@[diff](default.txt)

Message using ```make_my_diffs_pretty!```:

@[diff](better.txt)

Message using ```minitest_lucid```

@[ruby](lucid.txt)
