RSpec.shared_examples "index valid json" do |key|
  it "returns valid JSON" do
    body = JSON.parse(subject.body)
    expect(body[key].length).to eq(1)
    expect(body["meta"]).to be_present
  end
end
