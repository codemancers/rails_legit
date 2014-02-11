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
