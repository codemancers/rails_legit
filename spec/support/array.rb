shared_examples "basic array validations" do
  context "Invalid Array" do
    let(:array) { "Invalid Array" }
    it { should be_invalid }
  end

  context "Valid Array" do
    let(:array) { [1, 2, 3] }
    it { should be_valid }
  end
end


# Setup Classes

class TestRecordWithNoExtraOptions
  include ActiveModel::Validations
  include RailsLegit

  validates :array, verify_array: true

  attr_accessor :array
  def initialize(array)
    @array = array
  end
end

class TestRecordWithNoExtraOptionsMultipleAttributes
  include ActiveModel::Validations
  include RailsLegit

  validates :array, :anotherarray, verify_array: true

  attr_accessor :array, :anotherarray
  def initialize(array, anotherarray)
    @array = array
    @anotherarray = anotherarray
  end
end

class TestRecordWithMultipleAttributesInOptionSymbol
  include ActiveModel::Validations
  include RailsLegit

  validates :array, :anotherarray, verify_array: { in: :some_other_array }

  attr_accessor :array, :anotherarray
  def initialize(array, anotherarray)
    @array = array
    @anotherarray = anotherarray
  end


  def some_other_array
    [1, 2, 3, 4]
  end
end

class TestRecordWithMultipleAttributesNotInOptionSymbol
  include ActiveModel::Validations
  include RailsLegit

  validates :array, :anotherarray, verify_array: { not_in: :some_other_array }

  attr_accessor :array, :anotherarray
  def initialize(array, anotherarray)
    @array = array
    @anotherarray = anotherarray
  end


  def some_other_array
    [1, 2, 3, 4]
  end
end

class TestRecordWithMultipleAttributesInOptionArray
  include ActiveModel::Validations
  include RailsLegit

  validates :array, :anotherarray, verify_array: { in: [1, 2, 3, 4] }

  attr_accessor :array, :anotherarray
  def initialize(array, anotherarray)
    @array = array
    @anotherarray = anotherarray
  end
end

class TestRecordWithMultipleAttributesNotInOptionArray
  include ActiveModel::Validations
  include RailsLegit

  validates :array, :anotherarray, verify_array: { not_in: [1, 2, 3, 4] }

  attr_accessor :array, :anotherarray
  def initialize(array, anotherarray)
    @array = array
    @anotherarray = anotherarray
  end
end

class TestRecordWithMultipleAttributesInOptionProc
  include ActiveModel::Validations
  include RailsLegit

  validates :array, :anotherarray, verify_array: { in: ->{ [1, 2, 3, 4] } }

  attr_accessor :array, :anotherarray
  def initialize(array, anotherarray)
    @array = array
    @anotherarray = anotherarray
  end
end

class TestRecordWithMultipleAttributesNotInOptionProc
  include ActiveModel::Validations
  include RailsLegit

  validates :array, :anotherarray, verify_array: { not_in: ->{ [1, 2, 3, 4] } }

  attr_accessor :array, :anotherarray
  def initialize(array, anotherarray)
    @array = array
    @anotherarray = anotherarray
  end
end
