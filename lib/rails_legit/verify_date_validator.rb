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

      date_to_check = try_to_convert_to_date(value)

      if value.nil?
        record.errors.add(attribute, "Can't be nil")
        return
      end

      unless date_to_check
        record.errors.add(attribute, "Invalid Date Format")
        return
      end

      comparisions.each do |key, value|
        date_to_be_checked_with_before_type_cast = value.is_a?(Symbol) ? record.send(value) : value
        date_to_be_checked_with = try_to_convert_to_date(date_to_be_checked_with_before_type_cast)

        unless date_to_be_checked_with.send(VALID_COMPARISIONS[key], date_to_check)
          if date_to_check < Date.current
            record.errors.add(attribute, "Occurs in the past")
          else
            message = "Occurs before #{value.to_s.humanize}"
            record.errors.add(attribute, message)
          end
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
          if Date.respond_to? v
            comparisions[k] = Date.send v
          else
            comparisions[k] = v
          end
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
