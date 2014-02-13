module RailsLegit
  module Errors
    class NilValueError < StandardError
      def message
        "The value supplied for comparision was nil"
      end
    end
  end
end
