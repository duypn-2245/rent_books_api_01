RSpec.shared_examples "count after action" do |model, count|
  it "creates successfull" do
    expect{subject}.to change(model, :count).by(count)
  end
end
