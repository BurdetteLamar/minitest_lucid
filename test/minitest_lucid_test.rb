require 'minitest_lucid'

class MinitestLucidTest < Minitest::Test

  # make_my_diffs_pretty!

  def test_version
    refute_nil ::MinitestLucid::VERSION
  end

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
    msg = 'My message'
    lucid = <<EOT
Message:  #{msg}
Expected class:  #{expected.class}
Actual class:  #{actual.class}
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
EOT
    x = assert_raises (Minitest::Assertion) do
      assert_equal(expected, actual, msg)
    end
    assert_match(Regexp.new(lucid, Regexp::MULTILINE), x.message)
  end

  def test_set
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
    lucid = <<EOT
Message:  #{msg}
Expected class:  #{expected.class}
Actual class:  #{actual.class}
elucidation = {
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
EOT
    x = assert_raises (Minitest::Assertion) do
      assert_equal(expected, actual, msg)
    end
    assert_match(Regexp.new(lucid, Regexp::MULTILINE), x.message)
  end

  def test_struct
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
