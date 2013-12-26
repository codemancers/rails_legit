module RailsLegit
  class DateValidator < ActiveModel::Validator
    attr_accessor :date, :date_to_be_compared_with
    attr_accessor :attribute

    def initialize(options)
      @attribute = options.delete(:attributes).first
      super
    end

    def validate(record)
      date_string = record.send attribute
      return false if date_string.blank?

      options.values.each do |comparison_date_string|
        if comparison_date_string.in?([:current_date, :today])
          @date_to_be_compared_with = Date.current
        end

        if comparison_date_string.in?([:from_date, :to_date])
          unless @date_to_be_compared_with = convert_dates_to_objects(record.send(comparison_date_string))
            record.errors.add(comparison_date_string, "Invalid Date Format")
          end
        end
      end

      unless convert_dates_to_objects(date_string)
        record.errors.add(attribute, "Invalid Date Format")
      end

      if options[:greater_than]
        if date < date_to_be_compared_with
          record.errors.add(attribute, I18n.t("app.errors.messages.occurs_before_from_date"))
        end
      end
    end

    def convert_dates_to_objects(string)
      begin
        self.date = Date.parse(string)
      rescue ArgumentError
        false
      end
    end
  end
end
