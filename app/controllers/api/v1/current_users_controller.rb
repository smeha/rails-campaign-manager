module Api
  module V1
    class CurrentUsersController < BaseController
      def show
        render json: {
          id: sess_current_user.id,
          name: sess_current_user.name,
          email: sess_current_user.email
        }
      end
    end
  end
end
