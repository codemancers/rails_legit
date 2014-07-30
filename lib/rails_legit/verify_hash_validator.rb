module RailsLegit
  class VerifyHashValidator < ActiveModel::EachValidator

    VALID_COMPARISIONS = [
      :keys,
      :values
    ].freeze

    attr_accessor :comparisions

    def initialize(options)
      super
      @comparisions = {}
      process_options!
    end

    def validate_each(record, attribute, value)
      unless value.is_a?(Hash)
        record.errors.add(attribute, options[:message] || "Not a Hash")
        return
      end


      comparisions.each do |k, v|
        if v.nil?
          raise ArgumentError, "Cannot compare with nil"
        elsif v.is_a?(Symbol)
          if record.respond_to?(v, true)
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

    private

    def compare_both_arrays(record_hash, verification_array, attribute, type_of_comparision, record)
      case type_of_comparision
      when :keys
        record_array_set = SortedSet.new(record_hash.keys)
        verification_array_set = SortedSet.new(verification_array)
      when :values
        record_array_set = SortedSet.new(record_hash.values)
        verification_array_set = SortedSet.new(verification_array)
      end

      unless record_array_set.subset?(verification_array_set)
        record.errors.add(attribute, options[:message] || "The given array is not a subset of #{verification_array}. Expected it to not be one")
      end
    end

    def process_options!
      options.slice(*VALID_COMPARISIONS).each do |k, v|
        unless v.is_a?(Proc) || v.is_a?(Symbol) || v.is_a?(Array)
          raise ArgumentError, "You need to specify either an Array or a Symbol or a Proc that returns an Array as an option value"
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
