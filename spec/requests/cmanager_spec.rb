require "rails_helper"

RSpec.describe "Campaign manager", type: :request do
  describe "GET /" do
    it "renders the landing page" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Manage banners and campaigns from one small dashboard.")
    end
  end

  describe "GET /cmanager/index" do
    it "renders the index page" do
      get cmanager_index_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("How it works")
    end
  end
end
