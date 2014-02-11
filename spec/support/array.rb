shared_examples "basic array validations" do
  context "Invalid Array" do
    let(:array) { "Invalid Array" }
    it { should be_invalid }
  end

  context "Valid Array" do
    let(:array) { [1, 2, 3] }
    it { should be_valid }
  end
end
