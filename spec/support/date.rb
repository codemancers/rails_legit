require "active_model"

shared_examples "basic date validations" do

  context "Invalid Date" do
    let(:date) { "Invalid Date" }
    it { should be_invalid }
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

# Setup Classes

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

class TestRecordWithMultipleAttributesBeforeOptionCurrentSymbol
  include ActiveModel::Validations
  include RailsLegit

  validates :date, :anotherdate, verify_date: { before: :today }

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
