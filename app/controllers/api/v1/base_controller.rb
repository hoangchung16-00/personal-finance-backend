module Api
  module V1
    class BaseController < ApplicationController
      # Skip CSRF token verification for API requests
      # API clients will authenticate using tokens (e.g., JWT, API keys)
      # rather than session-based cookies that are vulnerable to CSRF
      skip_before_action :verify_authenticity_token

      before_action :authenticate_request

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
      rescue_from ActionController::ParameterMissing, with: :bad_request

      private

      def not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def unprocessable_entity(exception)
        render json: { error: exception.message, details: exception.record.errors }, status: :unprocessable_entity
      end

      def bad_request(exception)
        render json: { error: exception.message }, status: :bad_request
      end

      def authenticate_request
        api_key = extract_api_key_from_header
        @current_user = User.authenticate_by_api_key(api_key)

        unless @current_user
          render json: { error: "Invalid or missing API key" }, status: :unauthorized
        end
      end

      def extract_api_key_from_header
        # Check for API key in Authorization header
        # Format: "Authorization: Bearer <api_key>"
        auth_header = request.headers["Authorization"]
        return nil unless auth_header

        # Extract the token from "Bearer <token>"
        auth_header.split(" ").last if auth_header.start_with?("Bearer ")
      end

      def current_user
        @current_user
      end
    end
  end
end
