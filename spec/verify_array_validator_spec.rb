require "spec_helper"
require "active_model"

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
