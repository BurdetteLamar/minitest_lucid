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

  class MyHash < Hash; end
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
    lucid_format = <<EOT

{
  :message => '%s and %s',
  :expected => {
    :class => %s,
    :size => 6,
  },
  :actual => {
    :class => %s,
    :size => 6,
  },
  :elucidation => {
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
}
EOT

    my_expected = MyHash.new.merge(expected)
    my_actual = MyHash.new.merge(actual)
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
      lucid = format(lucid_format, exp.class, act.class, exp.class, act.class)
      assert_match(Regexp.new(lucid, Regexp::MULTILINE), x.message)
    end

  end

  class MySet < Set; end
  def zzz_test_set
    expected = Set.new([
        'Cia ina do ip ocat doat.',
        'Dua sarat rad noad maat caea.',
        'Eser in dolo eaata labor ut.',
        'Ipaat paal doat iruat ala magabor.',
        'Ut dolore ua consal vaba caea.',
        'Sunt sed te coma teu alaaame.',
        'Laboab vaga dat maaua in venima.',
        'Eser in dolo eaata labor ut.',
    ])
    actual = Set.new([
        'Cia ina do ip ocat doat.',
        'Dua sarat rad noad maat caea.',
        'eser in dolo eaata labor ut.',
        'ipaat paal doat iruat ala magabor.',
        'Ut dolore ua consal vaba caea.',
        'Sunt sed te coma teu alaaame.',
        'laboab vaga dat maaua in venima.',
        'eser in dolo eaata labor ut.',
    ])
    msg = 'My message'
    lucid_format = <<EOT
{
  :message => 'MinitestLucidTest::MyHash and Hash',
  :expected => {
    :class => MinitestLucidTest::MyHash,
    :size => 6,
  },
  :actual => {
    :class => Hash,
    :size => 6,
  },
  :elucidation => {
    :missing => {
      'Eser in dolo eaata labor ut.',
      'Ipaat paal doat iruat ala magabor.',
      'Laboab vaga dat maaua in venima.',
    },
    :unexpected => {
      'eser in dolo eaata labor ut.',
      'ipaat paal doat iruat ala magabor.',
      'laboab vaga dat maaua in venima.',
    },
    :ok => {
      'Cia ina do ip ocat doat.',
      'Dua sarat rad noad maat caea.',
      'Ut dolore ua consal vaba caea.',
      'Sunt sed te coma teu alaaame.',
    },
  }
}
EOT
    my_expected = MySet.new.merge(expected)
    my_actual = MySet.new.merge(actual)
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

  def zzz_test_struct
    Struct.new('MyStruct',
               :tauro,
               :loquens,
               :lor,
               :dolo,
               :offab,
               :moam,
               :laboru,
               :amcae,
    )
    expected = Struct::MyStruct.new(
        'Cia ina do ip ocat doat.',
        'Dua sarat rad noad maat caea.',
        'Eser in dolo eaata labor ut.',
        'Ipaat paal doat iruat ala magabor.',
        'Ut dolore ua consal vaba caea.',
        'Sunt sed te coma teu alaaame.',
        'Laboab vaga dat maaua in venima.',
        'Eser in dolo eaata labor ut.',
    )
    actual = Struct::MyStruct.new(
        'Cia ina do ip ocat doat.',
        'Dua sarat rad noad maat caea.',
        'eser in dolo eaata labor ut.',
        'ipaat paal doat iruat ala magabor.',
        'Ut dolore ua consal vaba caea.',
        'Sunt sed te coma teu alaaame.',
        'laboab vaga dat maaua in venima.',
        'eser in dolo eaata labor ut.',
    )
    msg = 'My message'
    lucid = <<EOT
Message:  #{msg}
Expected class:  #{expected.class}
Actual class:  #{actual.class}
elucidation = {
  :changed_values => {
    :lor => {
      :expected => 'Eser in dolo eaata labor ut.',
      :got      => 'eser in dolo eaata labor ut.',
    },
    :dolo => {
      :expected => 'Ipaat paal doat iruat ala magabor.',
      :got      => 'ipaat paal doat iruat ala magabor.',
    },
    :laboru => {
      :expected => 'Laboab vaga dat maaua in venima.',
      :got      => 'laboab vaga dat maaua in venima.',
    },
    :amcae => {
      :expected => 'Eser in dolo eaata labor ut.',
      :got      => 'eser in dolo eaata labor ut.',
    },
  },
  :ok_values => {
    :tauro => 'Cia ina do ip ocat doat.',
    :loquens => 'Dua sarat rad noad maat caea.',
    :offab => 'Ut dolore ua consal vaba caea.',
    :moam => 'Sunt sed te coma teu alaaame.',
  },
}
EOT
    x = assert_raises (Minitest::Assertion) do
      assert_equal(expected, actual, msg)
    end
    assert_match(Regexp.new(lucid, Regexp::MULTILINE), x.message)
  end

end
