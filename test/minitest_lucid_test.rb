require 'diff-lcs'
require 'test_helper'

require 'minitest_lucid/version'

class MinitestLucidTest < Minitest::Test

  # make_my_diffs_pretty!

  def test_version
    refute_nil ::MinitestLucid::VERSION
  end

  class MyArray < Array; end
  def zzz_test_array
    expected = [
        'Cia ina do ip ocat doat.',
        'Dua sarat rad noad maat caea.',
        'Eser in dolo eaata labor ut.',
        'Ipaat paal doat iruat ala magabor.',
        'Ut dolore ua consal vaba caea.',
        'Sunt sed te coma teu alaaame.',
        'Laboab vaga dat maaua in venima.',
        'Eser in dolo eaata labor ut.',
    ]
    actual = [
        'Cia ina do ip ocat doat.',
        'dua sarat rad noad maat caea.',
        'Ut dolore ua consal vaba caea.',
        'Sunt sed te coma teu alaaame.',
        'Eser in dolo eaata labor ut.',
        'Ipaat paal doat iruat ala magabor.',
        'laboab vaga dat maaua in venima.',
        'Eser in dolo eaata labor ut.',
    ]
    lucid_format = <<EOT
Message:  %s
Expected class:  %s
Actual class:  %s
elucidation = [
  {
    :status => :unchanged,
    :old_index_0 => "Cia ina do ip ocat doat.",
    :new_index_0 => "Cia ina do ip ocat doat.",
  },
  {
    :status => :changed,
    :old_index_1 => "Dua sarat rad noad maat caea.",
    :new_index_1 => "dua sarat rad noad maat caea.",
  },
  {
    :status => :missing,
    :old_index_2 => "Eser in dolo eaata labor ut.",
  },
  {
    :status => :missing,
    :old_index_3 => "Ipaat paal doat iruat ala magabor.",
  },
  {
    :status => :unchanged,
    :old_index_4 => "Ut dolore ua consal vaba caea.",
    :new_index_2 => "Ut dolore ua consal vaba caea.",
  },
  {
    :status => :unchanged,
    :old_index_5 => "Sunt sed te coma teu alaaame.",
    :new_index_3 => "Sunt sed te coma teu alaaame.",
  },
  {
    :status => :changed,
    :old_index_6 => "Laboab vaga dat maaua in venima.",
    :new_index_4 => "Eser in dolo eaata labor ut.",
  },
  {
    :status => :unexpected,
    :new_index_5 => "Ipaat paal doat iruat ala magabor.",
  },
  {
    :status => :unexpected,
    :new_index_6 => "laboab vaga dat maaua in venima.",
  },
  {
    :status => :unchanged,
    :old_index_7 => "Eser in dolo eaata labor ut.",
    :new_index_7 => "Eser in dolo eaata labor ut.",
  },
]

EOT
    my_expected = MyArray.new + expected
    my_actual = MyArray.new + actual
    [
        [expected, actual],
        [my_expected, actual],
        [expected, my_actual],
        [my_expected, my_actual]
    ].each do |pair|
      exp, act = *pair
      msg = "#{exp.class} and #{act.class}"
      x = assert_raises (Minitest::Assertion) do
        assert_equal(exp, act, msg)
      end
      lucid = format(lucid_format, msg, exp.class, act.class)
      assert_match(Regexp.new(lucid, Regexp::MULTILINE), x.message)
    end
  end

  class SubHash < Hash; end
  def test_hash
    expected = {
        :tauro => 'Cia ina do ip ocat doat.',
        :loquens => 'Dua sarat rad noad maat caea.',
        :lor => 'Eser in dolo eaata labor ut.',
        :dolo => 'Ipaat paal doat iruat ala magabor.',
        :offab => 'Ut dolore ua consal vaba caea.',
        :moam => 'Sunt sed te coma teu alaaame.',
    }
    actual = {
        :laboru => 'Laboab vaga dat maaua in venima.',
        :dolo => 'Ipaat paal doat iruat ala magabor.',
        :loquens => 'dua sarat rad noad maat caea.',
        :lor => 'Eser in dolo eaata labor ut.',
        :tauro => 'cia ina do ip ocat doat.',
        :amcae => 'Utatu cilaa cit siat commag seqa.',
    }
    sub_expected = SubHash.new.merge(expected)
    sub_actual = SubHash.new.merge(actual)
    [
        [expected, actual],
        [sub_expected, actual],
        [expected, sub_actual],
        [sub_expected, sub_actual]
    ].each do |pair|
      do_test(Hash, *pair)
    end
  end

  class SubSet < Set; end
  def test_set
    expected = Set.new([
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
    actual = Set.new([
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
    msg = 'My message'
    sub_expected = SubSet.new.merge(expected)
    sub_actual = SubSet.new.merge(actual)
    [
        [expected, actual],
        [sub_expected, actual],
        [expected, sub_actual],
        [sub_expected, sub_actual]
    ].each do |pair|
      do_test(Set, *pair)
    end
  end

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

  class SubStruct < Struct::MyStruct; end

  def test_struct
    expected = Struct::MyStruct.new(
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
    actual = Struct::MyStruct.new(
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
        'Si voaabor alit occaaa.',
    )
    sub_expected = SubStruct.new(*expected.to_h.values)
    sub_actual = SubStruct.new(*actual.to_h.values)
    struct_dir_path = File.join(File.dirname(__FILE__), 'struct')
    Dir.chdir(struct_dir_path) do
      [
          [expected, actual],
          [sub_expected, actual],
          [expected, sub_actual],
          [sub_expected, sub_actual],
      ].each do |pair|
        do_test(Struct::MyStruct, *pair)
      end
    end
  end

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
      exp_file_path = "expected/#{exp_name}.#{act_name}.txt"
      act_file_path = "actual/#{exp_name}.#{act_name}.txt"
      File.write(act_file_path, x.message)
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
