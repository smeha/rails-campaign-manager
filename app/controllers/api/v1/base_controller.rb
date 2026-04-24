module Api
  module V1
    class BaseController < ApplicationController
      before_action :require_api_authentication

      private

      def require_api_authentication
        return if sess_loggedin?

        render json: { error: "unauthorized" }, status: :unauthorized
      end

      def render_validation_errors(record)
        render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
