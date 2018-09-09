# Minitest Lucid

Use ```minitest_lucid``` to improve error messages from ```minitest```.


## Supported Classes

- [Hash](#hash)

### Hash

#### assert_equal

Here are the hashes, expected and actual, that we'll use for comparison:

```data.rb```:
```ruby
def expected
  {
      :tauro => 'Cia ina do ip ocat doat.',
      :loquens => 'Dua sarat rad noad maat caea.',
      :lor => 'Eser in dolo eaata labor ut.',
      :dolo => 'Ipaat paal doat iruat ala magabor.',
      :offab => 'Ut dolore ua consal vaba caea.',
      :moam => 'Sunt sed te coma teu alaaame.',
  }
end
def actual
  {
      :laboru => 'Laboab vaga dat maaua in venima.',
      :dolo => 'Ipaat paal doat iruat ala magabor.',
      :loquens => 'dua sarat rad noad maat caea.',
      :lor => 'Eser in dolo eaata labor ut.',
      :tauro => 'cia ina do ip ocat doat.',
      :amcae => 'Utatu cilaa cit siat commag seqa.',
  }
end
```

The default message:

```default.txt```:
```diff
--- expected
+++ actual
@@ -1 +1 @@
-{:tauro=>"Cia ina do ip ocat doat.", :loquens=>"Dua sarat rad noad maat caea.", :lor=>"Eser in dolo eaata labor ut.", :dolo=>"Ipaat paal doat iruat ala magabor.", :offab=>"Ut dolore ua consal vaba caea.", :moam=>"Sunt sed te coma teu alaaame."}
+{:laboru=>"Laboab vaga dat maaua in venima.", :dolo=>"Ipaat paal doat iruat ala magabor.", :loquens=>"dua sarat rad noad maat caea.", :lor=>"Eser in dolo eaata labor ut.", :tauro=>"cia ina do ip ocat doat.", :amcae=>"Utatu cilaa cit siat commag seqa."}
```

Message using ```make_my_diffs_pretty!```:

```better.txt```:
```diff
--- expected
+++ actual
@@ -1,6 +1,6 @@
-{:tauro=>"Cia ina do ip ocat doat.",
- :loquens=>"Dua sarat rad noad maat caea.",
- :lor=>"Eser in dolo eaata labor ut.",
+{:laboru=>"Laboab vaga dat maaua in venima.",
  :dolo=>"Ipaat paal doat iruat ala magabor.",
- :offab=>"Ut dolore ua consal vaba caea.",
- :moam=>"Sunt sed te coma teu alaaame."}
+ :loquens=>"dua sarat rad noad maat caea.",
+ :lor=>"Eser in dolo eaata labor ut.",
+ :tauro=>"cia ina do ip ocat doat.",
+ :amcae=>"Utatu cilaa cit siat commag seqa."}
```

Message using ```minitest_lucid```

```lucid.txt```:
```ruby

elucidation = {
    :missing_pairs => {
      :offab => 'Ut dolore ua consal vaba caea.',
      :moam => 'Sunt sed te coma teu alaaame.',
    },
    :unexpected_pairs => {
      :laboru => 'Laboab vaga dat maaua in venima.',
      :amcae => 'Utatu cilaa cit siat commag seqa.',
    },
    :changed_values => {
      :tauro => {
        :expected => 'Cia ina do ip ocat doat.',
        :got      => 'cia ina do ip ocat doat.',
      },
      :loquens => {
        :expected => 'Dua sarat rad noad maat caea.',
        :got      => 'dua sarat rad noad maat caea.',
      },
    },
    :ok_pairs => {
      :lor => 'Eser in dolo eaata labor ut.',
      :dolo => 'Ipaat paal doat iruat ala magabor.',
    },
}
```


