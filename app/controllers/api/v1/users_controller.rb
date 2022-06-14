module Api
  module V1
    class UsersController < ApplicationController
      def create
        @user = User.create!(user_params)
        render status: :created
      end

      private

      def user_params
        params.require(:user).permit(:username, :password)
      end
    end
  end
end
