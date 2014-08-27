module RailsLegit
  module Errors
    class NoMethodError < StandardError
      attr_reader :method_name

      def initialize(method_name)
        @method_name = method_name
        super
      end

      def message
        <<-EOS

Expected to find a method named #{method_name} to be defined but
failed. Perhaps, the method is defined as a protected method?

Only those methods defined as private or public can be accessible.
EOS
      end
    end
  end
end
