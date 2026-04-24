require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create_user }

  def submit_login(email: user.email, password: RequestAuthHelpers::DEFAULT_PASSWORD)
    post login_path, params: { session: { email: email, password: password } }
  end

  describe "GET /login" do
    it "renders the login page" do
      get login_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Welcome Back")
    end
  end

  describe "POST /login" do
    it "logs the user in with valid credentials" do
      submit_login
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to match(/Successfully logged in.*View Campaigns/m)
    end

    it "re-renders the form for invalid credentials" do
      submit_login(password: "bad-password")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Incorrect credentials")
    end
  end

  describe "DELETE /logout" do
    before { sign_in_as(user) }

    it "logs the user out" do
      delete logout_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to match(/Successfully logged out.*Create Account/m)
    end
  end
end
