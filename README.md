# Minitest Lucid

Use ```minitest_lucid``` to improve error messages from ```minitest```.


## Supported Classes

- [Hash](#hash)
- [Set](#set)

### Hash

#### assert_equal

Here are hashes, expected and actual, to be compared.

```data.rb```:
```ruby
def expected
  {
      :ina => 'Alita tea loat qani.',
      :con => 'Et sia adid qua.',
      :dolupi => 'Parali coal alit qad.',
      :enaam => 'La ofadi aliq caat.',
      :qat => 'Magna voaa aaliqu maan.',
      :vent => 'Do velaa volor na.',
      :suata => 'Fadi iame adati na.',
      :ip => 'Utat iram adip voan.',
      :ex => 'Vat eiua exca inci.',
      :labor => 'Aut tatat proam iat.',
      :occaag => 'Co nulab nost paat.',
      :alitaaa => 'Eaam fugatia exat quis.',
      :cidaa => 'Enia adiaamea deseaat eliqui.',
      :eaalabalab => 'Aut te magna aliq.',
      :ut => 'Param ad dua idatu.',
      :ullaboa => 'Irat cona doat dunt.',
      :ipsum => 'Irur na nuaata doaga.',
      :duat => 'Noaga idat sara ex.',
      :anis => 'Sint adipi et aut.',
  }
end
def actual
  {
      :ina => 'Alita tea loat qani.',
      :con => 'Et sia adid qua.',
      :euaaag => 'Enta adaad idess utetu.',
      :enaam => 'la ofadi aliq caat.',
      :qat => 'Magna voaa aaliqu maan.',
      :vent => 'do velaa volor na.',
      :eaarisau => 'Taabore magn naatat in.',
      :ip => 'Utat iram adip voan.',
      :ex => 'Vat eiua exca inci.',
      :labor => 'aut tatat proam iat.',
      :esedat => 'Dola labor eu null.',
      :alitaaa => 'Eaam fugatia exat quis.',
      :cidaa => 'enia adiaamea deseaat eliqui.',
      :eaalabalab => 'Aut te magna aliq.',
      :cat => 'Cullum pa quip magat.',
      :ullaboa => 'Irat cona doat dunt.',
      :ipsum => 'Irur na nuaata doaga.',
      :duat => 'Noaga idat sara ex.',
      :eua => 'Quat comm laal inaa.',
  }
end
```

The default ```Minitest::Assertion``` message:

```default.txt```:
```diff
--- expected
+++ actual
@@ -1 +1 @@
-{:ina=>"Alita tea loat qani.", :con=>"Et sia adid qua.", :dolupi=>"Parali coal alit qad.", :enaam=>"La ofadi aliq caat.", :qat=>"Magna voaa aaliqu maan.", :vent=>"Do velaa volor na.", :suata=>"Fadi iame adati na.", :ip=>"Utat iram adip voan.", :ex=>"Vat eiua exca inci.", :labor=>"Aut tatat proam iat.", :occaag=>"Co nulab nost paat.", :alitaaa=>"Eaam fugatia exat quis.", :cidaa=>"Enia adiaamea deseaat eliqui.", :eaalabalab=>"Aut te magna aliq.", :ut=>"Param ad dua idatu.", :ullaboa=>"Irat cona doat dunt.", :ipsum=>"Irur na nuaata doaga.", :duat=>"Noaga idat sara ex.", :anis=>"Sint adipi et aut."}
+{:ina=>"Alita tea loat qani.", :con=>"Et sia adid qua.", :euaaag=>"Enta adaad idess utetu.", :enaam=>"la ofadi aliq caat.", :qat=>"Magna voaa aaliqu maan.", :vent=>"do velaa volor na.", :eaarisau=>"Taabore magn naatat in.", :ip=>"Utat iram adip voan.", :ex=>"Vat eiua exca inci.", :labor=>"aut tatat proam iat.", :esedat=>"Dola labor eu null.", :alitaaa=>"Eaam fugatia exat quis.", :cidaa=>"enia adiaamea deseaat eliqui.", :eaalabalab=>"Aut te magna aliq.", :cat=>"Cullum pa quip magat.", :ullaboa=>"Irat cona doat dunt.", :ipsum=>"Irur na nuaata doaga.", :duat=>"Noaga idat sara ex.", :eua=>"Quat comm laal inaa."}
```

Message using ```make_my_diffs_pretty!```:

```better.txt```:
```diff
--- expected
+++ actual
@@ -1,19 +1,19 @@
 {:ina=>"Alita tea loat qani.",
  :con=>"Et sia adid qua.",
- :dolupi=>"Parali coal alit qad.",
- :enaam=>"La ofadi aliq caat.",
+ :euaaag=>"Enta adaad idess utetu.",
+ :enaam=>"la ofadi aliq caat.",
  :qat=>"Magna voaa aaliqu maan.",
- :vent=>"Do velaa volor na.",
- :suata=>"Fadi iame adati na.",
+ :vent=>"do velaa volor na.",
+ :eaarisau=>"Taabore magn naatat in.",
  :ip=>"Utat iram adip voan.",
  :ex=>"Vat eiua exca inci.",
- :labor=>"Aut tatat proam iat.",
- :occaag=>"Co nulab nost paat.",
+ :labor=>"aut tatat proam iat.",
+ :esedat=>"Dola labor eu null.",
  :alitaaa=>"Eaam fugatia exat quis.",
- :cidaa=>"Enia adiaamea deseaat eliqui.",
+ :cidaa=>"enia adiaamea deseaat eliqui.",
  :eaalabalab=>"Aut te magna aliq.",
- :ut=>"Param ad dua idatu.",
+ :cat=>"Cullum pa quip magat.",
  :ullaboa=>"Irat cona doat dunt.",
  :ipsum=>"Irur na nuaata doaga.",
  :duat=>"Noaga idat sara ex.",
- :anis=>"Sint adipi et aut."}
+ :eua=>"Quat comm laal inaa."}
```

Message using ```minitest_lucid```

```lucid.txt```:
```ruby

{
  :expected => {
    :class => Hash,
    :size => 19,
  },
  :actual => {
    :class => Hash,
    :size => 19,
  },
  :elucidation => {
    :missing_pairs => {
      :dolupi => 'Parali coal alit qad.',
      :suata => 'Fadi iame adati na.',
      :occaag => 'Co nulab nost paat.',
      :ut => 'Param ad dua idatu.',
      :anis => 'Sint adipi et aut.',
    },
    :unexpected_pairs => {
      :euaaag => 'Enta adaad idess utetu.',
      :eaarisau => 'Taabore magn naatat in.',
      :esedat => 'Dola labor eu null.',
      :cat => 'Cullum pa quip magat.',
      :eua => 'Quat comm laal inaa.',
    },
    :changed_values => {
      :enaam => {
        :expected => 'La ofadi aliq caat.',
        :got      => 'la ofadi aliq caat.',
      },
      :vent => {
        :expected => 'Do velaa volor na.',
        :got      => 'do velaa volor na.',
      },
      :labor => {
        :expected => 'Aut tatat proam iat.',
        :got      => 'aut tatat proam iat.',
      },
      :cidaa => {
        :expected => 'Enia adiaamea deseaat eliqui.',
        :got      => 'enia adiaamea deseaat eliqui.',
      },
    },
    :ok_pairs => {
      :ina => 'Alita tea loat qani.',
      :con => 'Et sia adid qua.',
      :qat => 'Magna voaa aaliqu maan.',
      :ip => 'Utat iram adip voan.',
      :ex => 'Vat eiua exca inci.',
      :alitaaa => 'Eaam fugatia exat quis.',
      :eaalabalab => 'Aut te magna aliq.',
      :ullaboa => 'Irat cona doat dunt.',
      :ipsum => 'Irur na nuaata doaga.',
      :duat => 'Noaga idat sara ex.',
    },
  }
}
```

### Set

#### assert_equal

Here are sets, expected and actual, to be compared.

```data.rb```:
```ruby
def expected
  Set.new([
              'Eia do elab same.',
              'Uati nua iaam caea.',
              'Nulla paal dolor maatat.',
              'Exerad iame ulpa ipari.',
              'Veaat ea conaaectat noat.',
              'Euaab voat doloa caecat.',
              'Idatia naat paaat inia.',
              'Prem fatiaa fad ulpaat.',
              'Ea re deni utat.',
              'Irud ming fat int.',
              'Utaag quis aut ing.',
              'Siaa miaation vagna alaa.',
              'Ut dolla laat nonse.',
              'Enaat alam nonse magnaat.',
              'Sequaa nulp duisic na.',
              'Seqa quips sitataa exae.',
              'Vate eu adip quata.',
              'Tatua ididun offia doaut.',
          ])
end
def actual
  Set.new([
              'Euaab voat doloa caecat.',
              'Suntat fugiame sici exad.',
              'Idatia naat paaat inia.',
              'Ea re deni utat.',
              'Eia do elab same.',
              'Nulla paal dolor maatat.',
              'Dolo mod eaamet ena.',
              'Exerad iame ulpa ipari.',
              'Ut dolla laat nonse.',
              'Sequaa nulp duisic na.',
              'Dat dolor laboat caalit.',
              'Seqa quips sitataa exae.',
              'Dolo esera id samcomaa.',
              'Irud ming fat int.',
              'Siaa miaation vagna alaa.',
              'Cuate adid do nim.',
              'Tatua ididun offia doaut.',
              'Ocaada iaamaa fatioa anaat.',
          ])
end
```

The default ```Minitest::Assertion``` message:

```default.txt```:
```diff
--- expected
+++ actual
@@ -1 +1 @@
-#<Set: {"Eia do elab same.", "Uati nua iaam caea.", "Nulla paal dolor maatat.", "Exerad iame ulpa ipari.", "Veaat ea conaaectat noat.", "Euaab voat doloa caecat.", "Idatia naat paaat inia.", "Prem fatiaa fad ulpaat.", "Ea re deni utat.", "Irud ming fat int.", "Utaag quis aut ing.", "Siaa miaation vagna alaa.", "Ut dolla laat nonse.", "Enaat alam nonse magnaat.", "Sequaa nulp duisic na.", "Seqa quips sitataa exae.", "Vate eu adip quata.", "Tatua ididun offia doaut."}>
+#<Set: {"Euaab voat doloa caecat.", "Suntat fugiame sici exad.", "Idatia naat paaat inia.", "Ea re deni utat.", "Eia do elab same.", "Nulla paal dolor maatat.", "Dolo mod eaamet ena.", "Exerad iame ulpa ipari.", "Ut dolla laat nonse.", "Sequaa nulp duisic na.", "Dat dolor laboat caalit.", "Seqa quips sitataa exae.", "Dolo esera id samcomaa.", "Irud ming fat int.", "Siaa miaation vagna alaa.", "Cuate adid do nim.", "Tatua ididun offia doaut.", "Ocaada iaamaa fatioa anaat."}>
```

Message using ```make_my_diffs_pretty!```:

```better.txt```:
```diff
--- expected
+++ actual
@@ -1,18 +1,18 @@
-#<Set: {"Eia do elab same.",
- "Uati nua iaam caea.",
- "Nulla paal dolor maatat.",
- "Exerad iame ulpa ipari.",
- "Veaat ea conaaectat noat.",
- "Euaab voat doloa caecat.",
+#<Set: {"Euaab voat doloa caecat.",
+ "Suntat fugiame sici exad.",
  "Idatia naat paaat inia.",
- "Prem fatiaa fad ulpaat.",
  "Ea re deni utat.",
- "Irud ming fat int.",
- "Utaag quis aut ing.",
- "Siaa miaation vagna alaa.",
+ "Eia do elab same.",
+ "Nulla paal dolor maatat.",
+ "Dolo mod eaamet ena.",
+ "Exerad iame ulpa ipari.",
  "Ut dolla laat nonse.",
- "Enaat alam nonse magnaat.",
  "Sequaa nulp duisic na.",
+ "Dat dolor laboat caalit.",
  "Seqa quips sitataa exae.",
- "Vate eu adip quata.",
- "Tatua ididun offia doaut."}>
+ "Dolo esera id samcomaa.",
+ "Irud ming fat int.",
+ "Siaa miaation vagna alaa.",
+ "Cuate adid do nim.",
+ "Tatua ididun offia doaut.",
+ "Ocaada iaamaa fatioa anaat."}>
```

Message using ```minitest_lucid```

```lucid.txt```:
```ruby

{
  :expected => {
    :class => Set,
    :size => 18,
  },
  :actual => {
    :class => Set,
    :size => 18,
  },
  :elucidation => {
    :missing => {
      'Uati nua iaam caea.',
      'Veaat ea conaaectat noat.',
      'Prem fatiaa fad ulpaat.',
      'Utaag quis aut ing.',
      'Enaat alam nonse magnaat.',
      'Vate eu adip quata.',
    },
    :unexpected => {
      'Suntat fugiame sici exad.',
      'Dolo mod eaamet ena.',
      'Dat dolor laboat caalit.',
      'Dolo esera id samcomaa.',
      'Cuate adid do nim.',
      'Ocaada iaamaa fatioa anaat.',
    },
    :ok => {
      'Euaab voat doloa caecat.',
      'Idatia naat paaat inia.',
      'Ea re deni utat.',
      'Eia do elab same.',
      'Nulla paal dolor maatat.',
      'Exerad iame ulpa ipari.',
      'Ut dolla laat nonse.',
      'Sequaa nulp duisic na.',
      'Seqa quips sitataa exae.',
      'Irud ming fat int.',
      'Siaa miaation vagna alaa.',
      'Tatua ididun offia doaut.',
    },
  }
}
```



