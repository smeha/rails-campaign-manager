module Api
  module V1
    class CampaignsController < BaseController
      def index
        render json: sess_current_user.campaigns.includes(:banner).order(created_at: :desc).map(&:api_payload)
      end

      def create
        campaign = sess_current_user.campaigns.build(campaign_params)

        if campaign.save
          render json: campaign.api_payload, status: :created
        else
          render_validation_errors(campaign)
        end
      end

      def destroy
        sess_current_user.campaigns.find(params[:id]).destroy!
        head :no_content
      end

      private

      def campaign_params
        params.require(:campaign).permit(:name, :start_date, :end_date, :start_time, :end_time, :banner_id)
      end
    end
  end
end
