require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /register" do
    it "creates the user" do
      post "/api/v1/users/register", params: {user: {username: "user1", password: "password_12345"}}

      expect(response).to have_http_status(:created)

      expect(json).to eq({
        "id" => User.last.id,
        "username" => "user1",
        "token" => AuthenticationTokenService.call(User.last.id)
      })
    end
  end
end
