require "spec_helper"
require "active_model"

class TestRecordWithNoExtraOptions
  include ActiveModel::Validations
  include RailsLegit

  validates :date, date: true

  attr_accessor :date
  def initialize(date)
    @date = date
  end
end

class TestRecordWithNoExtraOptionsMultipleAttributes
  include ActiveModel::Validations
  include RailsLegit

  validates :date, :anotherdate, date: true

  attr_accessor :date, :anotherdate
  def initialize(date, anotherdate)
    @date = date
    @anotherdate = anotherdate
  end
end

describe RailsLegit::DateValidator do
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
end
