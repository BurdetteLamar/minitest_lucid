require 'set'

module Minitest

  module Assertions

    class LucidSet

      def self.elucidate(exception, expected, actual)
        missing = expected - actual
        unexpected = actual - expected
        ok = expected & actual
        Assertions.elucidate(exception, expected, actual) do |body_ele, toc_ul_ele|
          Minitest::Assertions.elucidate_missing_items(body_ele, toc_ul_ele, missing)
          Minitest::Assertions.elucidate_unexpected_items(body_ele, toc_ul_ele, unexpected)
          Minitest::Assertions.elucidate_ok_items(body_ele, toc_ul_ele, ok)
        end
      end

    end

  end

end