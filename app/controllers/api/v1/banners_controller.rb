module Api
  module V1
    class BannersController < BaseController
      def index
        render json: sess_current_user.banners.order(created_at: :desc).map { |banner| banner_payload(banner) }
      end

      def create
        banner = sess_current_user.banners.build(banner_params)

        if banner.save
          render json: banner_payload(banner), status: :created
        else
          render_validation_errors(banner)
        end
      end

      def destroy
        sess_current_user.banners.find(params[:id]).destroy!
        head :no_content
      end

      private

      def banner_params
        params.require(:banner).permit(:name, :text)
      end

      def banner_payload(banner)
        {
          id: banner.id,
          name: banner.name,
          text: banner.text
        }
      end
    end
  end
end
