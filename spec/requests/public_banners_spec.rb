require "rails_helper"

RSpec.describe "Public banners", type: :request do
  let(:lookup_time) { Time.iso8601("2026-04-23T13:15:00+02:00") }
  let(:lookup) { instance_double(ClientTimeLookup, call: lookup_time) }
  let(:user) { create_user }

  describe "GET /publicbanner/:ip" do
    before do
      allow(ClientTimeLookup).to receive(:new).and_return(lookup)
    end

    context "with a same-day time window" do
      let(:banner) { user.banners.create!(name: "Lunch", text: "Lunch promo") }

      before do
        user.campaigns.create!(
          name: "Lunch campaign",
          start_date: Date.new(2026, 4, 20),
          end_date: Date.new(2026, 4, 30),
          start_time: "13:00",
          end_time: "15:00",
          banner_id: banner.id
        )
      end

      it "returns a currently eligible banner" do
        get "/publicbanner/195.110.64.205"

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq("Lunch promo")
      end
    end

    context "with an overnight window carried from the previous active date" do
      let(:lookup_time) { Time.iso8601("2026-04-24T00:15:00+02:00") }
      let(:banner) { user.banners.create!(name: "Overnight", text: "Overnight promo") }

      before do
        user.campaigns.create!(
          name: "Overnight campaign",
          start_date: Date.new(2026, 4, 23),
          end_date: Date.new(2026, 4, 24),
          start_time: "23:00",
          end_time: "02:00",
          banner_id: banner.id
        )
      end

      it "matches after midnight when the previous date was active" do
        get "/publicbanner/195.110.64.205"

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq("Overnight promo")
      end
    end

    context "without a previous active date for the overnight window" do
      let(:lookup_time) { Time.iso8601("2026-04-23T00:15:00+02:00") }
      let(:banner) { user.banners.create!(name: "Late", text: "Late promo") }

      before do
        user.campaigns.create!(
          name: "Late campaign",
          start_date: Date.new(2026, 4, 23),
          end_date: Date.new(2026, 4, 30),
          start_time: "23:00",
          end_time: "02:00",
          banner_id: banner.id
        )
      end

      it "does not match before the first active date has started" do
        get "/publicbanner/195.110.64.205"

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq("Not Found")
      end
    end

    context "without a matching campaign" do
      it "returns not found when no banner matches the date and time window" do
        get "/publicbanner/195.110.64.205"

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq("Not Found")
      end
    end
  end
end
