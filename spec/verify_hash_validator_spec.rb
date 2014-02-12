require "spec_helper"
require "support/hash"

describe RailsLegit::VerifyHashValidator do
  describe "No Extra Options provided" do
    let(:record) { NoExtraOptionsHash.new(hash) }
    subject { record }

    context "Valid Hash" do
      let(:hash) { { one: 1, two: 2, three: 3, four: 4 } }
      it { should be_valid }
    end

    context "Invalid Hash" do
      let(:hash) { "Invalid Hash" }

      it { should_not be_valid }
      it "should attach error on appropriate method" do
        record.valid?
        expect(record.errors[:hash]).to include("Not a Hash")
      end
    end
  end

  describe "No Extra Options provided and multiple attributes" do
    let(:record) { NoOptionsMultipleAttributesHash.new(hash, anotherhash) }
    let(:anotherhash) { {one: 1, two: 2} }
    subject { record }

    context "Valid Hash" do
      let(:hash) { {one: 1, two: 2, three: 3} }
      it { should be_valid }
    end

    context "Invalid Hash on comparision method" do
      let(:anotherhash) { "Invalid Hash" }
      let(:hash) { { one: 1, two: 2, three: 3 } }

      it { should_not be_valid }
      it "should attach error on appropriate method" do
        record.valid?
        expect(record.errors[:anotherhash]).to include("Not a Hash")
      end
    end
  end

  describe "Individual Keys and Values options, Multiple attributes, Valid case" do
    let(:hash) { { one: 1, two: 2, three: 3 } }
    let(:anotherhash) { { four: 4, three: 3 } }
    subject { record }

    context "Keys as the option" do
      context "comparision object is a Proc" do
        let(:record) { MultipleAttributesKeysOptionProc.new(hash, anotherhash) }

        it { should be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { MultipleAttributesKeysOptionSymbol.new(hash, anotherhash) }

        it { should be_valid }
      end

      context "comparision object is Array" do
        let(:record) { MultipleAttributesKeysOptionArray.new(hash, anotherhash) }

        it { should be_valid }
      end
    end

    context "Values as the option" do
      context "comparision object is a Proc" do
        let(:record) { MultipleAttributesValuesOptionProc.new(hash, anotherhash) }

        it { should be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { MultipleAttributesValuesOptionSymbol.new(hash, anotherhash) }

        it { should be_valid }
      end

      context "comparision object is Array" do
        let(:record) { MultipleAttributesValuesOptionArray.new(hash, anotherhash) }

        it { should be_valid }
      end
    end
  end

  describe "Individual Keys and Values options, Multiple attributes, Invalid case" do
    let(:hash) { { seven: 7, eight: 8, nine: 9 } }
    let(:anotherhash) { { ten: 10, eleven: 11 } }
    subject { record }

    context "Keys as the option" do
      context "comparision object is a Proc" do
        let(:record) { MultipleAttributesKeysOptionProc.new(hash, anotherhash) }

        it { should_not be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { MultipleAttributesKeysOptionSymbol.new(hash, anotherhash) }

        it { should_not be_valid }
      end

      context "comparision object is Array" do
        let(:record) { MultipleAttributesKeysOptionArray.new(hash, anotherhash) }

        it { should_not be_valid }
      end
    end

    context "Values as the option" do
      context "comparision object is a Proc" do
        let(:record) { MultipleAttributesValuesOptionProc.new(hash, anotherhash) }

        it { should_not be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { MultipleAttributesValuesOptionSymbol.new(hash, anotherhash) }

        it { should_not be_valid }
      end

      context "comparision object is Array" do
        let(:record) { MultipleAttributesValuesOptionArray.new(hash, anotherhash) }

        it { should_not be_valid }
      end
    end
  end

  describe "Both Keys and Values options, Multiple attributes, Valid case" do
    let(:hash) { { one: 1, two: 2, three: 3 } }
    let(:anotherhash) { { four: 4, three: 3 } }
    subject { record }

      context "comparision object is a Proc" do
        let(:record) { MultipleAttributesKeysValuesOptionProc.new(hash, anotherhash) }

        it { should be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { MultipleAttributesKeysValuesOptionSymbol.new(hash, anotherhash) }

        it { should be_valid }
      end

      context "comparision object is Array" do
        let(:record) { MultipleAttributesKeysValuesOptionArray.new(hash, anotherhash) }

        it { should be_valid }
      end
  end

  describe "Both Keys and Values options, Multiple attributes, Invalid case" do
    let(:hash) { { five: 5, six: 6, seven: 7 } }
    let(:anotherhash) { { nine: 9, ten: 10 } }
    subject { record }

      context "comparision object is a Proc" do
        let(:record) { MultipleAttributesKeysValuesOptionProc.new(hash, anotherhash) }

        it { should_not be_valid }
      end

      context "comparision object is a Symbol" do
        let(:record) { MultipleAttributesKeysValuesOptionSymbol.new(hash, anotherhash) }

        it { should_not be_valid }
      end

      context "comparision object is Array" do
        let(:record) { MultipleAttributesKeysValuesOptionArray.new(hash, anotherhash) }

        it { should_not be_valid }
      end
  end
end
