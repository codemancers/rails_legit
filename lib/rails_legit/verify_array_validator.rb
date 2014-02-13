module RailsLegit
  class VerifyArrayValidator < ActiveModel::EachValidator

    VALID_COMPARISIONS = [
      :in, :not_in, :eq
    ].freeze

    attr_accessor :comparisions

    def initialize(options)
      super
      @comparisions = {}
      process_options!
    end

    def validate_each(record, attribute, value)
      unless value.is_a?(Array)
        record.errors.add(attribute, "Not an Array")
        return
      end

      comparisions.each do |k, v|
        if v.nil?
          raise ArgumentError, "Cannot compare an array with nil"
        elsif v.is_a?(Symbol)
          if record.respond_to?(v) || record.class.private_method_defined?(v)
            array_to_be_compared_with = record.send(v)
            if array_to_be_compared_with && array_to_be_compared_with.is_a?(Array)
              compare_both_arrays(value, array_to_be_compared_with, attribute, k, record)
            else
              raise ArgumentError, "The comparision value was not an Array or didn't evaluate to an Array. It was #{array_to_be_compared_with}"
            end
          else
            raise NoMethodError, "No method named #{v} on the record supplied"
          end
        elsif v.is_a?(Array)
          compare_both_arrays(value, v, attribute, k, record)
        else
          raise ArgumentError, "The comparision can be done against an array or a Proc that evaluates to an array"
        end
      end
    end

    def check_validity!
      options.keys.each do |key|
        unless VALID_COMPARISIONS.member?(key)
          raise ArgumentError, "Valid keys for options are #{VALID_COMPARISIONS.join(', ')}"
        end
      end
    end

    private

    def compare_both_arrays(record_array, verification_array, attribute, type_of_comparision, record)
      record_array_set = SortedSet.new(record_array)
      verification_array_set = SortedSet.new(verification_array)

      case type_of_comparision
      when :in
        unless record_array_set.subset?(verification_array_set)
          record.errors.add(attribute, "The given array is not a subset of #{verification_array}. Expected it to not be one")
        end
      when :not_in
        if record_array_set.subset?(verification_array_set)
          record.errors.add(attribute, "The given array is a subset of #{verification_array}. Expected it to not be one")
        end
      when :eq
        unless record_array_set == verification_array_set
          record.errors.add(attribute, "The given array is not equal to #{verification_array}. Expected it to be equal")
        end
      end
    end

    def process_options!
      options.each do |k, v|
        unless v.is_a?(Proc) || v.is_a?(Symbol) || v.is_a?(Array)
          raise ArgumentError, "Valid values for options are a Proc or Symbol or an Array"
        end

        if v.is_a?(Proc)
          comparisions[k] = v.call
        elsif v.is_a?(Array) || v.is_a?(Symbol)
          comparisions[k] = v
        end
      end
    end
  end
end
