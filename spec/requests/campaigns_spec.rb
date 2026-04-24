require "rails_helper"

RSpec.describe "Campaigns", type: :request do
  let(:user) { create_user }

  describe "GET /users/:user_id/campaigns" do
    it "redirects guests to login" do
      get user_campaigns_path(user)

      expect(response).to redirect_to(login_path)
    end

    it "renders the campaign workspace for signed-in users" do
      sign_in_as(user)

      get user_campaigns_path(user)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Campaign workspace")
    end
  end

  describe "GET /showcampaign" do
    let(:other_user) { create_user(email: "other-campaign-owner@example.com") }
    let!(:own_banner) { user.banners.create!(name: "Own banner", text: "Own text") }
    let!(:own_campaign) do
      user.campaigns.create!(
        name: "Primary campaign",
        start_date: Date.current,
        end_date: Date.current + 7,
        banners_id: own_banner.id
      )
    end

    before do
      other_banner = other_user.banners.create!(name: "Other banner", text: "Other text")
      other_user.campaigns.create!(
        name: "Other campaign",
        start_date: Date.current,
        end_date: Date.current + 7,
        banners_id: other_banner.id
      )
      sign_in_as(user)
    end

    it "returns only the current user's campaigns" do
      get "/showcampaign"

      expect(parsed_json_body).to contain_exactly(
        a_hash_including("id" => own_campaign.id, "name" => "Primary campaign", "banners_id" => own_banner.id)
      )
    end
  end

  describe "POST /newcampaign" do
    let!(:banner) { user.banners.create!(name: "Launch", text: "Launch copy") }
    let(:campaign_params) do
      {
        campaign: {
          name: "Launch campaign",
          start_date: Date.current.iso8601,
          end_date: (Date.current + 3).iso8601,
          start_time: "09:00",
          end_time: "17:00",
          banners_id: banner.id
        }
      }
    end

    before { sign_in_as(user) }

    it "creates a campaign for the signed-in user" do
      expect { post "/newcampaign", params: campaign_params, as: :json }.to change(user.campaigns, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(parsed_json_body).to include("name" => "Launch campaign", "banners_id" => banner.id)
    end
  end

  describe "DELETE /deletecampaign/:id" do
    let!(:banner) { user.banners.create!(name: "Launch", text: "Launch copy") }
    let!(:campaign) do
      user.campaigns.create!(
        name: "Delete campaign",
        start_date: Date.current,
        end_date: Date.current + 2,
        banners_id: banner.id
      )
    end

    before { sign_in_as(user) }

    it "deletes a signed-in user's campaign" do
      expect { delete "/deletecampaign/#{campaign.id}", as: :json }.to change(user.campaigns, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
