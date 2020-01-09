module Minitest

  module Assertions

    class LucidSet
      def self.elucidate(exception, expected, actual)
        missing = expected - actual
        unexpected = actual - expected
        ok = expected & actual
        Assertions.elucidate(exception, expected, actual) do
          Minitest::Assertions.elucidate_missing_items( missing)
          Minitest::Assertions.elucidate_unexpected_items( unexpected)
          Minitest::Assertions.elucidate_ok_items(ok)
        end
      end
    end

  end

end