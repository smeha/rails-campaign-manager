require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:valid_user_params) do
    {
      name: "New User",
      email: "new-user@example.com",
      password: RequestAuthHelpers::DEFAULT_PASSWORD,
      password_confirmation: RequestAuthHelpers::DEFAULT_PASSWORD
    }
  end

  let(:invalid_user_params) do
    {
      name: "",
      email: "invalid-email",
      password: "",
      password_confirmation: ""
    }
  end

  describe "GET /newuser" do
    it "renders the signup page" do
      get newuser_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Create an account")
    end
  end

  describe "POST /users" do
    it "creates a user and signs them in" do
      expect { post users_path, params: { user: valid_user_params } }.to change(User, :count).by(1)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to match(/Succesfully signed up and logged in.*View Campaigns/m)
    end

    it "does not create a user with invalid params" do
      expect { post users_path, params: { user: invalid_user_params } }.not_to change(User, :count)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("The form contains")
    end
  end

  describe "GET /users/:id" do
    let(:user) { create_user(name: "Owner", email: "owner@example.com") }

    it "redirects guests to login" do
      get user_path(user)

      expect(response).to redirect_to(login_path)
    end

    it "shows the current user's profile" do
      sign_in_as(user)
      get user_path(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to match(/Owner.*owner@example.com/m)
    end

    it "redirects away from another user's profile" do
      other_user = create_user(name: "Other", email: "other@example.com")
      sign_in_as(user)

      get user_path(other_user)

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /api/v1/current_user" do
    it "returns an unauthorized payload for guests" do
      get "/api/v1/current_user"

      expect(response).to have_http_status(:unauthorized)
      expect(parsed_json_body).to eq("error" => "unauthorized")
    end

    it "returns the current user id for signed-in users" do
      user = create_user(name: "Current User", email: "current-user@example.com")
      sign_in_as(user)

      get "/api/v1/current_user"

      expect(response).to have_http_status(:ok)
      expect(parsed_json_body).to include("id" => user.id, "name" => "Current User", "email" => "current-user@example.com")
    end
  end
end
