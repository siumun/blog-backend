module Api
  module V1
    class FavoritesController < ApplicationController
      skip_before_action :verify_authenticity_token
      def index
        user = User.find_by(id: session[:user_id])
        unless user
                return render json: {
                  message: "Please Login first"
                }, status: :unauthorized
        end  
        favorites = user.favorites.includes(:post)

        render json: {
          favorites: favorites.map do |favorite|
            {
              id: favorite.id,
              post: {
                id: favorite.post.id,
                title: favorite.post.title,
                slug: favorite.post.slug,
                excerpt: favorite.post.excerpt,
                view_count: favorite.post.view_count,
                top_image_url: favorite.post.top_image_url
              }
            }
          end
        }, status: :ok
      end

      def create
        user = User.find_by(id: session[:user_id])

        unless user
          return render json: {
            messsage: "Please login first"
          }, status: :unauthorized
        end

        favorite = user.favorites.new(favorite_param)

        if favorite.save
          render json: {
            messsage: "Add favorite successfull",
            favorite: {
              id: favorite.id,
              user_id: favorite.user_id,
              post_id: favorite.post_id
            }
          }, status: :created
        else
            render json: {
              errors: favorite.errors.full_messages
            }, status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find_by(id: session[:user_id])
        unless user
          return render json: {
            message: "Please login first",
          }, status: :unauthorized
        end

        favorite = user.favorites.find_by(post_id: params[:post_id])

        unless favorite
          return render json: {
            message: "Favorite not found"
          }, status: :not_found
        end

        if favorite.destroy
          render json: {
            message: "Delete successfully"
          }, status: :ok
        else
          render json: {
            errors: favorite.errors.full_messages
          },status: :unprocessable_entity
        end
      end

      def status
        user = User.find_by(id: session[:user_id])
        unless user
          return render json: {
            logged_in: false,
            favorited: false
          }
        end

        favorited = user.favorites.exists?(post_id: params[:post_id])
        render json: {
            favorited: favorited
          }
      end


      private
      def favorite_param
        params.permit(:post_id)
      end
    end
  end
end

