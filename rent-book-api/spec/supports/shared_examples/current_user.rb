RSpec.shared_examples "login current_user" do |trait|
  let!(:current_user){FactoryBot.create(:user, trait)}

  before do
    token = JsonWebToken.encode(user_id: current_user.id)
    request.headers["Authorization"] = token
  end
end
