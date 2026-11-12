module Api
  module V1
    class UsersController < ApplicationController
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

      private

      def user_params
        params.permit(:name, :email, :password)
      end
    end
  end
end