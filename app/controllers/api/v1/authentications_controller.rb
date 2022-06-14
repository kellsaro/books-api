module Api
  module V1
    class AuthenticationsController < ApplicationController
      class AuthenticationError < StandardError; end

      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from AuthenticationError, with: :handle_unauthenticated

      def create
        if user
          raise AuthenticationError unless user.authenticate(params.require(:password))
          render status: :created
        else
          render json: { error: 'Wrong credentials' }, status: :unauthorized
        end
      end

      private

      def user
        @user ||= User.find_by(username: params.require(:username))
      end

      def parameter_missing(error)
        render json: { error: error.message }, status: :unprocessable_entity
      end

      def handle_unauthenticated
        render json: { error: 'Wrong credentials' }, status: :unauthorized
      end
    end
  end
end
