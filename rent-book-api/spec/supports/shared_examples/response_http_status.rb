RSpec.shared_examples "response http status" do |status|
  it "returns a http status" do
    subject
    expect(response).to have_http_status(status)
  end
end
