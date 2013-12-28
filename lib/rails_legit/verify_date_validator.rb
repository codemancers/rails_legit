module RailsLegit
  class VerifyDateValidator < ActiveModel::EachValidator

    VALID_COMPARISIONS = {
      :before => :<,
      :after => :>,
      :on => :==,
      :on_or_before => :<=,
      :on_or_after => :>=,
    }.freeze

    attr_accessor :comparisions

    def initialize(options)
      super
      @comparisions = {}
      process_options!
    end

    def validate_each(record, attribute, value)
      raise("#{attribute} can't be nil") if value.nil?

      unless date_to_check = try_to_convert_to_date(value)
        record.errors.add(attribute, "Invalid Date Format")
      end

      comparisions.each do |key, value|
        date_to_be_checked_with = value.is_a?(Symbol) ? record.send(value) : value

        unless date_to_check.send(VALID_COMPARISIONS[key], date_to_be_checked_with)
          record.errors.add(attribute, "Occurs before #{value}")
        end
      end
    end

    def check_validity!
      options.keys.each do |key|
        unless VALID_COMPARISIONS.member?(key)
          raise ArgumentError, "Valid keys for options are #{VALID_COMPARISIONS.keys.join(", ")}"
        end
      end
    end

    def process_options!
      options.each do |k, v|
        if v.respond_to?(:to_date)
          comparisions[k] = v.send(:to_date)
        elsif v.is_a? Proc
          comparisions[k] = v.call
        elsif v.is_a? Symbol
          comparisions[k] = v
        elsif date = try_to_convert_to_date(v)
          comparisions[k] = date
        else
          raise ArgumentError, "Unable to understand the value for #{k}"
        end
      end
    end

    def try_to_convert_to_date(arg)
      if arg.respond_to? :to_date
        arg.to_date
      else
        begin
          Date.parse(arg)
        rescue ArgumentError => e
          return false
        end
      end
    end

  end
end
