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

  validates :date, :todate, date: true

  attr_accessor :date, :todate
  def initialize(date, todate)
    @date = date
    @todate   = todate
  end
end

describe RailsLegit::DateValidator do
  describe "No Extra Options provided" do
    let(:record) { TestRecordWithNoExtraOptions.new(date) }
    subject { record }

    include_examples "basic date validations"
  end

  describe "No Extra Options provided and multiple attributes" do
    let(:record) { TestRecordWithNoExtraOptionsMultipleAttributes.new(date, anotherdate) }
    let(:anotherdate) { Date.today }
    subject { record }

    include_examples "basic date validations"
  end
end
