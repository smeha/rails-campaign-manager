require "rails_helper"

RSpec.describe "Campaign manager", type: :request do
  describe "GET /" do
    it "renders the landing page" do
      get root_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /cmanager/index" do
    it "renders the index page" do
      get cmanager_index_path

      expect(response).to have_http_status(:ok)
    end
  end
end
