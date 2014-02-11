require "spec_helper"
require "active_model"

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

describe RailsLegit::VerifyDateValidator do
  describe "No Extra Options provided" do
    let(:record) { TestRecordWithNoExtraOptions.new(array) }
    subject { record }

    include_examples "basic array validations"

    context "Invalid Array" do
      let(:array) { "Invalid Array" }

      it "should attach error on appropriate method" do
        record.valid?
        expect(record.errors[:array]).to include("Not an Array")
      end
    end
  end

  describe "No Extra Options provided and multiple attributes" do
    let(:record) { TestRecordWithNoExtraOptionsMultipleAttributes.new(array, anotherarray) }
    let(:anotherarray) { [1, 2, 3] }
    subject { record }

    include_examples "basic array validations"

    context "Invalid Array on comparision method" do
      let(:anotherarray) { "Invalid Array" }
      let(:array) { [1, 2, 3] }

      it "should attach error on appropriate method" do
        record.valid?
        expect(record.errors[:anotherarray]).to include("Not an Array")
      end
    end
  end

  describe "In option, multiple attributes, Valid case" do
    let(:array) { [1, 2, 3] }
    let(:anotherarray) { [4, 3] }
    subject { record }

    context "In validator" do
      context "comparision object is a Proc" do
        let(:record) { TestRecordWithMultipleAttributesInOptionProc.new(array, anotherarray) }

        it { should be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { TestRecordWithMultipleAttributesInOptionSymbol.new(array, anotherarray) }

        it { should be_valid }
      end

      context "comparision object is Array" do
        let(:record) { TestRecordWithMultipleAttributesInOptionArray.new(array, anotherarray) }

        it { should be_valid }
      end
    end

    context "NotIn validator" do
      context "comparision object is a Proc" do
        let(:record) { TestRecordWithMultipleAttributesNotInOptionProc.new(array, anotherarray) }

        it { should_not be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { TestRecordWithMultipleAttributesNotInOptionSymbol.new(array, anotherarray) }

        it { should_not be_valid }
      end

      context "comparision object is Array" do
        let(:record) { TestRecordWithMultipleAttributesNotInOptionArray.new(array, anotherarray) }

        it { should_not be_valid }
      end
    end
  end

  describe "In option, multiple attributes, Invalid case" do
    let(:array) { [4, 1, 5] }
    let(:anotherarray) { [8, 9] }
    subject { record }

    context "In validator" do
      context "comparision object is a Proc" do
        let(:record) { TestRecordWithMultipleAttributesInOptionProc.new(array, anotherarray) }

        it { should_not be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { TestRecordWithMultipleAttributesInOptionSymbol.new(array, anotherarray) }

        it { should_not be_valid }
      end

      context "comparision object is Array" do
        let(:record) { TestRecordWithMultipleAttributesInOptionArray.new(array, anotherarray) }

        it { should_not be_valid }
      end
    end

    context "NotIn validator" do
      context "comparision object is a Proc" do
        let(:record) { TestRecordWithMultipleAttributesNotInOptionProc.new(array, anotherarray) }

        it { should be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { TestRecordWithMultipleAttributesNotInOptionSymbol.new(array, anotherarray) }

        it { should be_valid }
      end

      context "comparision object is Array" do
        let(:record) { TestRecordWithMultipleAttributesNotInOptionArray.new(array, anotherarray) }

        it { should be_valid }
      end
    end
  end
end
