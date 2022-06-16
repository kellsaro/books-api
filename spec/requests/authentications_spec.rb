require "rails_helper"

RSpec.describe "Authentications", type: :request do
  describe "POST /login" do
    let(:user) { create(:user, username: "user1", password: "password_12345") }
    let(:login_url) { "/api/v1/authentications/login" }

    it "authenticates the user" do
      post login_url, params: {username: user.username, password: user.password}

      expect(response).to have_http_status(:created)
      expect(json).to eq({
        "id" => user.id,
        "username" => user.username,
        "token" => AuthenticationTokenService.call(user.id)
      })
    end

    it "returns error when username does not exists" do
      post login_url, params: {username: "ac", password: "p2"}

      expect(response).to have_http_status(:unauthorized)
      expect(json).to eq({
        "error" => "Wrong credentials"
      })
    end

    it "returns error when password is incorrect" do
      post login_url, params: {username: user.username, password: "p2"}

      expect(response).to have_http_status(:unauthorized)
      expect(json).to eq({
        "error" => "Wrong credentials"
      })
    end
  end
end
