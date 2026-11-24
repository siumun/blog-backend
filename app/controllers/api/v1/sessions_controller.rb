module Api
  module V1
    class SessionsController < ApplicationController
      skip_forgery_protection
      def create
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          session[:user_id] = user.id

          render json: {
            message: "Login successful",
            user: {
              id: user.id,
              name: user.name,
              email: user.email
            }
          }, status: :ok
        else
          render json: {
            errors: ["Invalid email or password"]
          }, status: :unauthorized
        end
      end

      def current
        user = User.find_by(id: session[:user_id])

        if user
          render json: {
            logged_in: true,
            user: {
              id: user.id,
              name: user.name,
              email: user.email
            }
          }
        else
          render json: {
            logged_in: false,
            user: nil
          }
        end
      end

      

      def destroy
        session.clear
        render json: {message: "Logged out successfully"}, status: :ok
      end
    end
  end
end
