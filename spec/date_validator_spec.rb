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

class TestRecordWithGreaterThanComparision
  include ActiveModel::Validations
  include RailsLegit
  attr_accessor :date, :comparision_date

  validates :date, date: { greater_than: :comparision_date }

  def initialize(date, comparision_date)
    @date = date
    @comparision_date = comparision_date
  end
end

describe RailsLegit::DateValidator do
  describe "No Extra Options provided" do
    let(:record) { TestRecordWithNoExtraOptions.new(date) }
    subject { record }

    include_examples "basic date validations"
  end
end
