module Api
  module V1
    class UsersController < ApplicationController
      skip_forgery_protection
      def create
        user = User.new(user_params)

        if user.save
          render json: {
            message: "Registration Successful",
            user: {
              id: user.id,
              name: user.name,
              email: user.email
            }
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def profile
        render json: {
          id: current_user.id,
          name: current_user.name,
          email: current_user.email
        }
      end

      def update_profile
        user = User.find_by(id: session[:user_id])

        unless user
          return render json: {
            message: "Please Login first"
          }, status: :unauthorized
        end

        if user.update_without_password(profile_params)
          render json: {
            message: "Profile updated successfully",
            user: {
              id: user.id,
              name: user.name,
              email: user.email
            }
          }, status: :ok
        else
          render json: {
            errors: user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:name, :email, :password)
      end

      def profile_params
        params.require(:user).permit(:name, :email)
      end
    end
  end
end