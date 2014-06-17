module RailsLegit
  class VerifyDateValidator < ActiveModel::EachValidator

    VALID_COMPARISIONS = {
      :before => :<,
      :after => :>,
      :on => :==,
      :on_or_before => :<=,
      :on_or_after => :>=,
    }.freeze

    VALID_CONDITIONALS = [
      :if, :unless
    ].freeze

    attr_accessor :comparisions, :conditionals

    def initialize(options)
      super
      @comparisions = {}
      @conditionals = {}

      process_options!
      process_conditionals!
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
        next unless date_to_be_checked_with

        # TODO: should check for :current instead
        message = if date_to_check < Date.today
                    "Occurs in the past"
                  else
                    "Occurs before #{value.to_s.humanize}"
                  end

        unless date_to_check.send(VALID_COMPARISIONS[key], date_to_be_checked_with)
          if conditionals_true_for(record)
            record.errors.add(attribute, message)
          end
        end
      end
    end

    def conditionals_true_for(record)
      conditionals_truthiness = true

      conditionals.each do |conditional, method|
        if conditional == :if
          conditionals_truthiness = !!record.send(method)
        else
          conditionals_truthiness = !record.send(method)
        end
      end

      conditionals_truthiness
    end

    def check_validity!
      comparisions = VALID_COMPARISIONS.keys.push *VALID_CONDITIONALS

      options.keys.each do |key|
        unless comparisions.member? key
          message = <<-MESSAGE
          \n
          Valid keys for comparisions are :#{VALID_COMPARISIONS.keys.join(', :')}
          RailsLegit also supports conditionals for the validations.
          Valid conditionals are :#{VALID_CONDITIONALS.join(', :')}
          MESSAGE

          raise ArgumentError, message
        end
      end
    end

    def process_options!
      options.each do |k, v|
        next if VALID_CONDITIONALS.member? k

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

    def process_conditionals!
      options.each do |k, v|
        next unless VALID_CONDITIONALS.member? k
        #TODO: The assumption here is that the if condition takes only a method.
        # But this can be similar to the other features on options clause
        @conditionals[k] = v
      end
    end

    def conditional_validations_present?
      @conditionals.any?
    end

    def try_to_convert_to_date(arg)
      if arg.respond_to? :to_date
        arg.to_date rescue false
      else
        begin
          Date.parse(arg.to_s)
        rescue ArgumentError => e
          return false
        end
      end
    end
  end
end
