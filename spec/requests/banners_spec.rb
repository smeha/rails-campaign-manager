require "rails_helper"

RSpec.describe "Banners", type: :request do
  let(:user) { create_user }

  describe "GET /users/:user_id/banners" do
    it "redirects guests to login" do
      get user_banners_path(user)

      expect(response).to redirect_to(login_path)
    end

    it "renders the banner workspace for signed-in users" do
      sign_in_as(user)

      get user_banners_path(user)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Banner library")
    end
  end

  describe "GET /api/v1/banners" do
    let(:other_user) { create_user(email: "other-banner-owner@example.com") }
    let!(:own_banner) { user.banners.create!(name: "Primary", text: "Primary banner") }

    before do
      other_user.banners.create!(name: "Other", text: "Other banner")
      sign_in_as(user)
    end

    it "returns only the current user's banners" do
      get "/api/v1/banners"

      expect(parsed_json_body).to contain_exactly(
        a_hash_including("id" => own_banner.id, "name" => "Primary", "text" => "Primary banner")
      )
    end
  end

  describe "POST /api/v1/banners" do
    let(:banner_params) do
      {
        banner: {
          name: "Spring Promo",
          text: "Save 20%"
        }
      }
    end

    before { sign_in_as(user) }

    it "creates a banner for the signed-in user" do
      expect { post "/api/v1/banners", params: banner_params, as: :json }.to change(user.banners, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(parsed_json_body).to include("name" => "Spring Promo", "text" => "Save 20%")
    end
  end

  describe "DELETE /api/v1/banners/:id" do
    let!(:banner) { user.banners.create!(name: "Delete Me", text: "Old banner") }

    before { sign_in_as(user) }

    it "deletes a signed-in user's banner" do
      expect { delete "/api/v1/banners/#{banner.id}", as: :json }.to change(user.banners, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
