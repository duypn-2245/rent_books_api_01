RSpec.shared_examples "login" do |trait|
  before do
    user = FactoryBot.create(:user, trait)
    token = JsonWebToken.encode(user_id: user.id)
    request.headers["Authorization"] = token
  end
end
