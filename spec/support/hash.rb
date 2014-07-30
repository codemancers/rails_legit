require "active_model"

# Setup Classes

class NoExtraOptionsHash
  include ActiveModel::Validations
  include RailsLegit

  validates :hash, verify_hash: true

  attr_accessor :hash
  def initialize(hash)
    @hash = hash
  end
end

class CustomErrorMessageHash
  include ActiveModel::Validations
  include RailsLegit

  validates :hash, verify_hash: { message: 'Custom Error Message'}

  attr_accessor :hash
  def initialize(hash)
    @hash = hash
  end
end

class BaseRecordHashValidator
  include ActiveModel::Validations
  include RailsLegit


  attr_accessor :hash, :anotherhash
  def initialize(hash, anotherhash)
    @hash = hash
    @anotherhash = anotherhash
  end

end

class NoOptionsMultipleAttributesHash < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: true
end

class MultipleAttributesKeysOptionSymbol < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { keys: :some_other_array }

  private

  def some_other_array
    [:one, :two, :three, :four, :five]
  end
end

class MultipleAttributesValuesOptionSymbol < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { values: :some_other_array }

  private

  def some_other_array
    [1, 2, 3, 4, 5]
  end
end

class MultipleAttributesKeysOptionArray < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { keys: [:one, :two, :three, :four] }
end

class MultipleAttributesValuesOptionArray < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { values: [1, 2, 3, 4] }
end

class MultipleAttributesKeysOptionProc < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { keys: ->{ [:one, :two, :three, :four] } }
end

class MultipleAttributesValuesOptionProc < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { values: ->{ [1, 2, 3, 4] } }
end

class MultipleAttributesKeysValuesOptionProc < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { keys: ->{ [:one, :two, :three, :four] }, values: ->{ [1, 2, 3, 4] } }
end

class MultipleAttributesKeysValuesOptionArray < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { keys: [:one, :two, :three, :four], values: [1, 2, 3, 4] }
end

class MultipleAttributesKeysValuesOptionSymbol < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { keys: :some_array, values: :some_other_array }

  def some_array
    [:one, :two, :three, :four]
  end

  private

  def some_other_array
    [1, 2, 3, 4]
  end
end
