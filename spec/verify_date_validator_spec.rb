require "spec_helper"
require "active_model"

class TestRecordWithNoExtraOptions
  include ActiveModel::Validations
  include RailsLegit

  validates :date, verify_date: true

  attr_accessor :date
  def initialize(date)
    @date = date
  end
end

class TestRecordWithNoExtraOptionsMultipleAttributes
  include ActiveModel::Validations
  include RailsLegit

  validates :date, :anotherdate, verify_date: true

  attr_accessor :date, :anotherdate
  def initialize(date, anotherdate)
    @date = date
    @anotherdate = anotherdate
  end
end

class TestRecordWithMultipleAttributesBeforeOption
  include ActiveModel::Validations
  include RailsLegit

  validates :date, :anotherdate, verify_date: { before: :before_date }

  attr_accessor :date, :anotherdate, :before_date
  def initialize(date, anotherdate, before_date)
    @date = date
    @anotherdate = anotherdate
    @before_date = before_date
  end
end

class TestRecordWithMultipleAttributesBeforeOptionProc
  include ActiveModel::Validations
  include RailsLegit

  validates :date, :anotherdate, verify_date: { before: ->{ Date.today + 1 } }

  attr_accessor :date, :anotherdate
  def initialize(date, anotherdate)
    @date = date
    @anotherdate = anotherdate
  end
end

describe RailsLegit::VerifyDateValidator do
  describe "No Extra Options provided" do
    let(:record) { TestRecordWithNoExtraOptions.new(date) }
    subject { record }

    include_examples "basic date validations"

    context "Invalid Date" do
      let(:date) { "Invalid Date" }

      it "should attach error on appropriate method" do
        record.valid?
        expect(record.errors[:date]).to include("Invalid Date Format")
      end
    end
  end

  describe "No Extra Options provided and multiple attributes" do
    let(:record) { TestRecordWithNoExtraOptionsMultipleAttributes.new(date, anotherdate) }
    let(:anotherdate) { Date.today }
    subject { record }

    include_examples "basic date validations"

    context "Invalid Date on comparision method" do
      let(:anotherdate) { "Invalid Date" }
      let(:date) { Date.today }

      it "should attach error on appropirate method" do
        record.valid?
        expect(record.errors[:anotherdate]).to include("Invalid Date Format")
      end
    end
  end

  describe "Before option, multiple attributes" do
    let(:date) { "12 december 1900" }
    subject { record }

    context "Dates in the past" do
      let(:anotherdate) { Date.today - 1 }

      context "comparision object is a Proc" do
        let(:record) { TestRecordWithMultipleAttributesBeforeOptionProc.new(date, anotherdate) }
        it { should be_valid }
      end

      context "comparision object is a Symbol" do
        let(:before_date) { Date.today + 1 }
        let(:record) { TestRecordWithMultipleAttributesBeforeOption.new(date, anotherdate, before_date) }

        it { should be_valid }
      end
    end

    context "Dates in the future" do
      let(:anotherdate) { Date.today + 100 }

      context "comparision object is a Proc" do
        let(:record) { TestRecordWithMultipleAttributesBeforeOptionProc.new(date, anotherdate) }
        it { should be_invalid }

        it "should attach error to the correct attribute" do
          record.valid?
          message = "Occurs before #{Date.today + 1}"
          expect(record.errors[:anotherdate]).to include(message)
        end
      end

      context "comparision object is a Symbol" do
        let(:before_date) { Date.today + 1 }
        let(:record) { TestRecordWithMultipleAttributesBeforeOption.new(date, anotherdate, before_date) }

        it { should be_invalid }

        it "should attach error to the correct attribute" do
          record.valid?
          expect(record.errors[:anotherdate]).to include("Occurs before before_date")
        end
      end
    end
  end
end
