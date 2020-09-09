RSpec.shared_examples "index valid json" do |key, count|
  it "returns valid JSON" do
    body = JSON.parse(subject.body)
    expect(body[key].length).to eq(count)
    expect(body["meta"]).to be_present
  end
end
