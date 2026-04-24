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

  describe "GET /api/v1/campaigns" do
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
      get "/api/v1/campaigns"

      expect(parsed_json_body).to contain_exactly(
        a_hash_including("id" => own_campaign.id, "name" => "Primary campaign", "banner_id" => own_banner.id)
      )
    end
  end

  describe "POST /api/v1/campaigns" do
    let!(:banner) { user.banners.create!(name: "Launch", text: "Launch copy") }
    let(:campaign_params) do
      {
        campaign: {
          name: "Launch campaign",
          start_date: Date.current.iso8601,
          end_date: (Date.current + 3).iso8601,
          start_time: "09:00",
          end_time: "17:00",
          banner_id: banner.id
        }
      }
    end

    let(:overnight_campaign_params) do
      campaign_params.deep_dup.tap do |params|
        params[:campaign][:end_date] = (Date.current + 1).iso8601
        params[:campaign][:start_time] = "23:00"
        params[:campaign][:end_time] = "00:00"
      end
    end
    let(:same_day_past_end_params) do
      campaign_params.deep_dup.tap do |params|
        params[:campaign][:start_time] = "23:00"
        params[:campaign][:end_time] = "22:00"
        params[:campaign][:end_date] = params[:campaign][:start_date]
      end
    end

    before { sign_in_as(user) }

    it "creates a campaign for the signed-in user" do
      expect { post "/api/v1/campaigns", params: campaign_params, as: :json }.to change(user.campaigns, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(parsed_json_body).to include("name" => "Launch campaign", "banner_id" => banner.id)
    end

    it "accepts an overnight campaign window" do
      expect { post "/api/v1/campaigns", params: overnight_campaign_params, as: :json }.to change(user.campaigns, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(parsed_json_body.fetch("start_time")).to include("23:00:00")
      expect(parsed_json_body.fetch("end_time")).to include("00:00:00")
    end

    it "rejects times that are not aligned to the hour" do
      invalid_params = campaign_params.deep_dup
      invalid_params[:campaign][:start_time] = "09:30"

      post "/api/v1/campaigns", params: invalid_params, as: :json

      expect(response).to have_http_status(422)
      expect(parsed_json_body.fetch("errors")).to include("Start time must be set on the hour")
    end

    it "rejects an earlier end time on the same date" do
      post "/api/v1/campaigns", params: same_day_past_end_params, as: :json

      expect(response).to have_http_status(422)
      expect(parsed_json_body.fetch("errors")).to include("End date and time must be later than the start date and time")
    end

    it "rejects identical start and end times" do
      invalid_params = campaign_params.deep_dup
      invalid_params[:campaign][:end_time] = invalid_params[:campaign][:start_time]

      post "/api/v1/campaigns", params: invalid_params, as: :json

      expect(response).to have_http_status(422)
      expect(parsed_json_body.fetch("errors")).to include("End time must be different from start time")
    end
  end

  describe "DELETE /api/v1/campaigns/:id" do
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
      expect { delete "/api/v1/campaigns/#{campaign.id}", as: :json }.to change(user.campaigns, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
