module Api
  module V1
    class SubscriptionsController < ApplicationController
      skip_forgery_protection only: [:create]
      def create
        subscription = Subscription.new(subparam)
        if subscription.save
          render json: {
            message: "Subcribe Successful",
            subscription: {
              id: subscription.id,
              email: subscription.email
            }
          }, ststus: :created
        else
          render json: {
            errors: subscription.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private
      def subparam
        params.permit(:email)
      end

    end
  end
end

