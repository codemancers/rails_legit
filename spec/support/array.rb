require "active_model"

# Setup Classes

class NoOptionsSingleAttribute
  include ActiveModel::Validations
  include RailsLegit

  validates :array, verify_array: true

  attr_accessor :array
  def initialize(array)
    @array = array
  end
end

class BaseRecord
  include ActiveModel::Validations
  include RailsLegit

  attr_accessor :array, :anotherarray

  def initialize(array, anotherarray)
    @array = array
    @anotherarray = anotherarray
  end
end


class CustomErrorMessageArray < BaseRecord
  validates :array, :anotherarray, verify_array: { in: [1, 2, 3, 4], message: 'Custom Error Message' }
end

class NoOptionsMultipleAttributes < BaseRecord
  validates :array, :anotherarray, verify_array: true
end

class MultipleAttributesInOptionArray < BaseRecord
  validates :array, :anotherarray, verify_array: { in: [1, 2, 3, 4] }
end

class MultipleAttributesNotInOptionArray < BaseRecord
  validates :array, :anotherarray, verify_array: { not_in: [1, 2, 3, 4] }
end

class MultipleAttributesInOptionProc < BaseRecord
  validates :array, :anotherarray, verify_array: { in: ->{ [1, 2, 3, 4] } }
end

class MultipleAttributesNotInOptionProc < BaseRecord
  validates :array, :anotherarray, verify_array: { not_in: ->{ [1, 2, 3, 4] } }
end

class MultipleAttributesInOptionSymbol < BaseRecord
  validates :array, :anotherarray, verify_array: { in: :some_other_array }

  private

  def some_other_array
    [1, 2, 3, 4]
  end
end

class MultipleAttributesNotInOptionSymbol < BaseRecord
  validates :array, :anotherarray, verify_array: { not_in: :some_other_array }

  private

  def some_other_array
    [1, 2, 3, 4]
  end
end

class MultipleAttributesBothOptionsSymbol < BaseRecord
  validates :array, :anotherarray, verify_array: { in: :some_array, not_in: :some_other_array }

  private

  def some_array
    [1, 2, 3, 4]
  end

  def some_other_array
    [5, 6, 7, 8]
  end
end

class MultipleAttributesBothOptionsProc < BaseRecord
  validates :array, :anotherarray, verify_array: { in: ->{ [1, 2, 3, 4] }, not_in: ->{ [5, 6, 7, 8] } }
end

class MultipleAttributesBothOptionsArray < BaseRecord
  validates :array, :anotherarray, verify_array: { in: [1, 2, 3, 4], not_in: [5, 6, 7, 8] }
end
