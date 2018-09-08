require 'minitest_lucid'

class MinitestLucidTest < Minitest::Test

  # make_my_diffs_pretty!

  def zzz_test_version
    refute_nil ::MinitestLucid::VERSION
  end

  def zzz_test_string
    assert_equal('foo', 'bar')
  end

  def zzz_test_dir
    expected = Dir.new(File.dirname(__FILE__))
    actual = Dir.new(File.join(File.dirname(__FILE__), '..'))
    assert_equal(expected, actual)
  end

  def zzz_test_file
    expected = File.new(__FILE__)
    actual = File.new(File.join(File.dirname(__FILE__), 'test_helper.rb'))
    assert_equal(expected, actual)
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
    expected = <<EOT
MinitestLucidTest#test_hash:
Exception:
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
      assert_equal(expected, actual)
    end
    # puts '++++++++++++++++++++'
    # puts expected
    # puts '++++++++++++++++++++'
    # puts x.message
    # puts '++++++++++++++++++++'
    # assert_match(Regexp.new(Regexp.escape(expected)), x.message)
  end

end
