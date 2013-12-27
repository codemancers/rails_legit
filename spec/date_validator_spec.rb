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

describe RailsLegit::DateValidator do
  let(:record) { TestRecordWithNoExtraOptions.new(date) }
  subject { record }

  context "Invalid Date" do
    let(:date) { "Invalid Date" }

    it "should be invalid" do
      expect(record).to be_invalid
    end

    it "should throw the appropriate error" do
      record.valid?
      expect(record.errors[:date]).to include("Invalid Date Format")
    end
  end


  context "Valid Date as a String" do
    let(:date) { "21 December 2013" }
    it { should be_valid }
  end

  context "Valid Date as a Date object" do
    let(:date) { Date.today }
    it { should be_valid }
  end

  context "Valid Date as a DateTime object" do
    let(:date) { DateTime.now }
    it { should be_valid }
  end

  context "Valid Date as a Time object" do
    let(:date) { Time.now }
    it { should be_valid }
  end
end
