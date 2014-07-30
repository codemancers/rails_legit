require "spec_helper"
require "support/array"

describe RailsLegit::VerifyArrayValidator do
  subject { record }

  describe "No Extra Options provided" do
    let(:record) { NoOptionsSingleAttribute.new(array) }

    context "Valid Array" do
      let(:array) { [1, 2, 3] }
      it { should be_valid }
    end

    context "Invalid Array" do
      let(:array) { "Invalid Array" }

      it { should_not be_valid }
      it "should attach error on appropriate method" do
        record.valid?
        expect(record.errors[:array]).to include("Not an Array")
      end
    end
  end

  describe "No Extra Options provided and multiple attributes" do
    let(:record) { NoOptionsMultipleAttributes.new(array, anotherarray) }
    let(:anotherarray) { [1, 2, 3] }

    context "Valid Array" do
      let(:array) { [1, 2, 3] }
      it { should be_valid }
    end

    context "Invalid Array on comparision method" do
      let(:anotherarray) { "Invalid Array" }
      let(:array) { [1, 2, 3] }

      it { should_not be_valid }
      it "should attach error on appropriate method" do
        record.valid?
        expect(record.errors[:anotherarray]).to include("Not an Array")
      end
    end
  end

  describe "Custom Error messages" do
    let(:array) { [1, 2, 3] }
    let(:anotherarray) { [9, 31] }

    context "In validator" do
      context "comparision object is Array" do
        let(:record) { CustomErrorMessageArray.new(array, anotherarray) }

        it { should_not be_valid }

        it 'should attach custom error on appropriate attribute' do
          record.valid?
          expect(record.errors[:anotherarray]).to include("Custom Error Message")
        end
      end
    end
  end

  describe "Multiple attributes, Valid case" do
    let(:array) { [1, 2, 3] }
    let(:anotherarray) { [4, 3] }

    context "In validator" do
      context "comparision object is a Proc" do
        let(:record) { MultipleAttributesInOptionProc.new(array, anotherarray) }

        it { should be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { MultipleAttributesInOptionSymbol.new(array, anotherarray) }

        it { should be_valid }
      end

      context "comparision object is Array" do
        let(:record) { MultipleAttributesInOptionArray.new(array, anotherarray) }

        it { should be_valid }
      end
    end

    context "NotIn validator" do
      context "comparision object is a Proc" do
        let(:record) { MultipleAttributesNotInOptionProc.new(array, anotherarray) }

        it { should_not be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { MultipleAttributesNotInOptionSymbol.new(array, anotherarray) }

        it { should_not be_valid }
      end

      context "comparision object is Array" do
        let(:record) { MultipleAttributesNotInOptionArray.new(array, anotherarray) }

        it { should_not be_valid }
      end
    end
  end

  describe "Multiple attributes, Invalid case" do
    let(:array) { [4, 1, 5] }
    let(:anotherarray) { [8, 9] }

    context "In validator" do
      context "comparision object is a Proc" do
        let(:record) { MultipleAttributesInOptionProc.new(array, anotherarray) }

        it { should_not be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { MultipleAttributesInOptionSymbol.new(array, anotherarray) }

        it { should_not be_valid }
      end

      context "comparision object is Array" do
        let(:record) { MultipleAttributesInOptionArray.new(array, anotherarray) }

        it { should_not be_valid }
      end
    end

    context "NotIn validator" do
      context "comparision object is a Proc" do
        let(:record) { MultipleAttributesNotInOptionProc.new(array, anotherarray) }

        it { should be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { MultipleAttributesNotInOptionSymbol.new(array, anotherarray) }

        it { should be_valid }
      end

      context "comparision object is Array" do
        let(:record) { MultipleAttributesNotInOptionArray.new(array, anotherarray) }

        it { should be_valid }
      end
    end
  end

  describe "Both Options, Valid case" do
    let(:array) { [1, 2] }
    let(:anotherarray) { [1, 2, 3, 4] }

    context "In validator" do
      context "comparision against Proc" do
        let(:record) { MultipleAttributesBothOptionsProc.new(array, anotherarray) }

        it { should be_valid }
      end

      context "comparision against Symbol" do
        let(:record) { MultipleAttributesBothOptionsSymbol.new(array, anotherarray) }

        it { should be_valid }
      end

      context "comparision against Array" do
        let(:record) { MultipleAttributesBothOptionsArray.new(array, anotherarray) }

        it { should be_valid }
      end
    end
  end

  describe "Both Options, Invalid case" do
    let(:array) { [5, 6] }
    let(:anotherarray) { [3, 4] }

    context "In validator" do
      context "comparision against Proc" do
        let(:record) { MultipleAttributesBothOptionsProc.new(array, anotherarray) }

        it { should_not be_valid }
      end

      context "comparision against Symbol" do
        let(:record) { MultipleAttributesBothOptionsSymbol.new(array, anotherarray) }

        it { should_not be_valid }
      end

      context "comparision against Array" do
        let(:record) { MultipleAttributesBothOptionsArray.new(array, anotherarray) }

        it { should_not be_valid }
      end
    end
  end
end
