module Api
  module V1
    class BaseController < ApplicationController
      # Skip CSRF token verification for API requests
      # API clients will authenticate using tokens (e.g., JWT, API keys)
      # rather than session-based cookies that are vulnerable to CSRF
      skip_before_action :verify_authenticity_token

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

      def current_user
        # TODO: Implement proper token-based authentication (JWT, API keys, or OAuth)
        # For now, return the first user. In production, this should validate an auth token
        # and return the authenticated user
        @current_user ||= User.first
      end
    end
  end
end
