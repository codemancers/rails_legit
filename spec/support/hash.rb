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

class MultipleAttributesKeyOptionSymbol < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { keys: :some_other_array }

  def some_other_array
    [:one, :two, :three, :four]
  end
end

class MultipleAttributesValueOptionSymbol < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { values: :some_other_array }

  def some_other_array
    [1, 2, 3, 4]
  end
end

class MultipleAttributesKeyOptionArray < BaseRecordHashValidator
  # TODO: We need to provide a HashWithIndifferentAccess functionality here
  validates :hash, :anotherhash, verify_hash: { keys: [:one, :two, :three, :four] }
end

class MultipleAttributesValueOptionArray < BaseRecordHashValidator
  # TODO: We need to provide a HashWithIndifferentAccess functionality here
  validates :hash, :anotherhash, verify_hash: { values: [1, 2, 3, 4] }
end

class MultipleAttributesKeyOptionProc < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { keys: ->{ [:one, :two, :three, :four] } }
end

class MultipleAttributesValueOptionProc < BaseRecordHashValidator
  validates :hash, :anotherhash, verify_hash: { values: ->{ [1, 2, 3, 4] } }
end
