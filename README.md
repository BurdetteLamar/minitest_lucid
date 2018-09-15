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

### Struct

#### assert_equal

Here are structs, expected and actual, to be compared.

```data.rb```:
```ruby
Struct.new('MyStruct',
           :cat,
           :etur,
           :est,
           :iam,
           :ent,
           :et,
           :aabor,
           :quaa,
           :quipa,
           :estat,
           :deseqama,
           :dolor,
           :occat,
           :enim,
           :sing,
           :ea,
           :sicingaeaada,
           :labam,
           :eaaua,
           :suaa,
           :amea,
           :magat,
           :lam,
           :re,
           :ex,
           )
def expected
  Struct::MyStruct.new(
    'Venia con maga qaboadaa.',
    'Esea alit ut ofabo.',
    'Etuata ing mina famcom.',
    'Irur ciat nullum nis.',
    'Sin maga eaaec aate.',
    'Idua amag la ip.',
    'Dolo cida maal exceaad.',
    'Exce exea autat alabaa.',
    'Oat adaa eser qatat.',
    'Paar seaali ocaabor prabo.',
    'Cona catat exat dolo.',
    'Miat dat adid labo.',
    'Coam ea naat caatati.',
    'Idaat cat do in.',
    'Ut quatat adaat excae.',
    'Adip iatatet auaa vea.',
    'In ex con ent.',
    'Oatiat in amcons adaature.',
    'Exatate labo ulla re.',
    'Auta te esta para.',
    'Ipia sea commol magna.',
    'Endenia eur in aliamaga.',
    'Noabor modo autaa aata.',
    'Ad irab ut cupar.',
    'Si voaabor alit occaaa.',
    )
end

def actual
  Struct::MyStruct.new(
    'venia con maga qaboadaa.',
    'esea alit ut ofabo.',
    'etuata ing mina famcom.',
    'irur ciat nullum nis.',
    'Sin maga eaaec aate.',
    'Idua amag la ip.',
    'Dolo cida maal exceaad.',
    'Exce exea autat alabaa.',
    'oat adaa eser qatat.',
    'paar seaali ocaabor prabo.',
    'cona catat exat dolo.',
    'miat dat adid labo.',
    'Coam ea naat caatati.',
    'Idaat cat do in.',
    'Ut quatat adaat excae.',
    'Adip iatatet auaa vea.',
    'in ex con ent.',
    'oatiat in amcons adaature.',
    'exatate labo ulla re.',
    'auta te esta para.',
    'Ipia sea commol magna.',
    'Endenia eur in aliamaga.',
    'Noabor modo autaa aata.',
    'Ad irab ut cupar.',
    )
end
```

The default ```Minitest::Assertion``` message:

```default.txt```:
```diff
--- expected
+++ actual
@@ -1 +1 @@
-#<struct Struct::MyStruct cat="Venia con maga qaboadaa.", etur="Esea alit ut ofabo.", est="Etuata ing mina famcom.", iam="Irur ciat nullum nis.", ent="Sin maga eaaec aate.", et="Idua amag la ip.", aabor="Dolo cida maal exceaad.", quaa="Exce exea autat alabaa.", quipa="Oat adaa eser qatat.", estat="Paar seaali ocaabor prabo.", deseqama="Cona catat exat dolo.", dolor="Miat dat adid labo.", occat="Coam ea naat caatati.", enim="Idaat cat do in.", sing="Ut quatat adaat excae.", ea="Adip iatatet auaa vea.", sicingaeaada="In ex con ent.", labam="Oatiat in amcons adaature.", eaaua="Exatate labo ulla re.", suaa="Auta te esta para.", amea="Ipia sea commol magna.", magat="Endenia eur in aliamaga.", lam="Noabor modo autaa aata.", re="Ad irab ut cupar.", ex="Si voaabor alit occaaa.">
+#<struct Struct::MyStruct cat="venia con maga qaboadaa.", etur="esea alit ut ofabo.", est="etuata ing mina famcom.", iam="irur ciat nullum nis.", ent="Sin maga eaaec aate.", et="Idua amag la ip.", aabor="Dolo cida maal exceaad.", quaa="Exce exea autat alabaa.", quipa="oat adaa eser qatat.", estat="paar seaali ocaabor prabo.", deseqama="cona catat exat dolo.", dolor="miat dat adid labo.", occat="Coam ea naat caatati.", enim="Idaat cat do in.", sing="Ut quatat adaat excae.", ea="Adip iatatet auaa vea.", sicingaeaada="in ex con ent.", labam="oatiat in amcons adaature.", eaaua="exatate labo ulla re.", suaa="auta te esta para.", amea="Ipia sea commol magna.", magat="Endenia eur in aliamaga.", lam="Noabor modo autaa aata.", re="Ad irab ut cupar.", ex=nil>
```

Message using ```make_my_diffs_pretty!```:

```better.txt```:
```diff
--- expected
+++ actual
@@ -1,26 +1,26 @@
 #<struct Struct::MyStruct
- cat="Venia con maga qaboadaa.",
- etur="Esea alit ut ofabo.",
- est="Etuata ing mina famcom.",
- iam="Irur ciat nullum nis.",
+ cat="venia con maga qaboadaa.",
+ etur="esea alit ut ofabo.",
+ est="etuata ing mina famcom.",
+ iam="irur ciat nullum nis.",
  ent="Sin maga eaaec aate.",
  et="Idua amag la ip.",
  aabor="Dolo cida maal exceaad.",
  quaa="Exce exea autat alabaa.",
- quipa="Oat adaa eser qatat.",
- estat="Paar seaali ocaabor prabo.",
- deseqama="Cona catat exat dolo.",
- dolor="Miat dat adid labo.",
+ quipa="oat adaa eser qatat.",
+ estat="paar seaali ocaabor prabo.",
+ deseqama="cona catat exat dolo.",
+ dolor="miat dat adid labo.",
  occat="Coam ea naat caatati.",
  enim="Idaat cat do in.",
  sing="Ut quatat adaat excae.",
  ea="Adip iatatet auaa vea.",
- sicingaeaada="In ex con ent.",
- labam="Oatiat in amcons adaature.",
- eaaua="Exatate labo ulla re.",
- suaa="Auta te esta para.",
+ sicingaeaada="in ex con ent.",
+ labam="oatiat in amcons adaature.",
+ eaaua="exatate labo ulla re.",
+ suaa="auta te esta para.",
  amea="Ipia sea commol magna.",
  magat="Endenia eur in aliamaga.",
  lam="Noabor modo autaa aata.",
  re="Ad irab ut cupar.",
- ex="Si voaabor alit occaaa.">
+ ex=nil>
```

Message using ```minitest_lucid```

```lucid.txt```:
```ruby

{
  :expected => {
    :class => Struct::MyStruct,
    :size => 25,
  },
  :actual => {
    :class => Struct::MyStruct,
    :size => 25,
  },
  :elucidation => {
    :changed_values => {
      :cat => {
        :expected => 'Venia con maga qaboadaa.',
        :got      => 'venia con maga qaboadaa.',
      },
      :etur => {
        :expected => 'Esea alit ut ofabo.',
        :got      => 'esea alit ut ofabo.',
      },
      :est => {
        :expected => 'Etuata ing mina famcom.',
        :got      => 'etuata ing mina famcom.',
      },
      :iam => {
        :expected => 'Irur ciat nullum nis.',
        :got      => 'irur ciat nullum nis.',
      },
      :quipa => {
        :expected => 'Oat adaa eser qatat.',
        :got      => 'oat adaa eser qatat.',
      },
      :estat => {
        :expected => 'Paar seaali ocaabor prabo.',
        :got      => 'paar seaali ocaabor prabo.',
      },
      :deseqama => {
        :expected => 'Cona catat exat dolo.',
        :got      => 'cona catat exat dolo.',
      },
      :dolor => {
        :expected => 'Miat dat adid labo.',
        :got      => 'miat dat adid labo.',
      },
      :sicingaeaada => {
        :expected => 'In ex con ent.',
        :got      => 'in ex con ent.',
      },
      :labam => {
        :expected => 'Oatiat in amcons adaature.',
        :got      => 'oatiat in amcons adaature.',
      },
      :eaaua => {
        :expected => 'Exatate labo ulla re.',
        :got      => 'exatate labo ulla re.',
      },
      :suaa => {
        :expected => 'Auta te esta para.',
        :got      => 'auta te esta para.',
      },
      :ex => {
        :expected => 'Si voaabor alit occaaa.',
        :got      => nil,
      },
    },
    :ok_values => {
      :ent => 'Sin maga eaaec aate.',
      :et => 'Idua amag la ip.',
      :aabor => 'Dolo cida maal exceaad.',
      :quaa => 'Exce exea autat alabaa.',
      :occat => 'Coam ea naat caatati.',
      :enim => 'Idaat cat do in.',
      :sing => 'Ut quatat adaat excae.',
      :ea => 'Adip iatatet auaa vea.',
      :amea => 'Ipia sea commol magna.',
      :magat => 'Endenia eur in aliamaga.',
      :lam => 'Noabor modo autaa aata.',
      :re => 'Ad irab ut cupar.',
    },
  }
}
```



