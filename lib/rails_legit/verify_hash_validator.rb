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
        record.errors.add(attribute, "Not a Hash")
        return
      end


      comparisions.each do |k, v|
        if v.nil?
          raise Errors::NilValueError
        elsif v.is_a?(Symbol)
          if record.respond_to?(v) || record.class.private_method_defined?(v)
            array_to_be_compared_with = record.send(v)
            if array_to_be_compared_with && array_to_be_compared_with.is_a?(Array)
              compare_both_arrays(value, array_to_be_compared_with, attribute, k, record)
            else
              raise Errors::NotAnArrayError, array_to_be_compared_with
           end
          else
            raise Errors::NoMethodError, v
          end
        elsif v.is_a?(Array)
         compare_both_arrays(value, v, attribute, k, record)
        else
          raise Errors::NotAnArrayError
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
        record.errors.add(attribute, "The given array is not a subset of #{verification_array}. Expected it to not be one")
      end
    end

    def process_options!
      options.each do |k, v|
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
