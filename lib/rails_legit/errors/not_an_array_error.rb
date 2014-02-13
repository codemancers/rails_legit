module RailsLegit
  module Errors
    class NotAnArrayError < StandardError
      attr_reader :supplied_value

      def initialize(supplied_computed_value)
        @supplied_value = supplied_computed_value
        super
      end


      def message
        supplied_value.nil? ? main_message : [main_message, extra_message].join("\n")
      end

      private

      def extra_message
        "The supplied value after computation was #{supplied_value.inspect}"
      end

      def main_message
        <<-EOS

The comparision value was not an Array, or it did not evaluate to an
Array.

The supplied value after computation was #{supplied_value.inspect}
EOS
      end
    end
  end
end
