module Api
  module V1
    class CommentsController < ApplicationController
      skip_forgery_protection
      def index
        post = Post.find_by(id: params[:post_id])
        unless post
          return render json: {
            message: "Post not found"
          }, status: :not_found
        end  

        comments = post.comments.includes(:user)

        render json: {
          comments: comments.map do |comment|
            {
              id: comment.id,
              user_id: comment.user_id,
              user_name: comment.user.name,
              body: comment.body,
              post_id: comment.post_id,
              parent_id: comment.parent_id
              
            }
          end
        }, status: :ok
      end

      def create
        post = Post.find_by(id: params[:post_id])
        unless post
          return render json: {
            message: "No post found"
          }, status: :not_found
        end

        user = User.find_by(id: session[:user_id])
        unless user
          return render json: {
            message: "Please login first"
          }, status: :unauthorized
        end

        comment = user.comments.new(comment_params)
        comment.post = post  #comment.user = user

        
        if params[:parent_id].present?
          parent_comment = post.comments.find_by(id: params[:parent_id])
          unless parent_comment
            return render json: {
              message: "Invalid parent comment"
            }, status: :unprocessable_entity
          end
          comment.parent = parent_comment
        end

        if comment.save
          render json: {
            message: "Comment Successfully",
            
            comment: {
              id: comment.id,
              user_id: comment.user_id,
              post_id: comment.post_id,
              parent_id: comment.parent_id,
              body: comment.body,
              user_name: comment.user.name
              
            }
          }, status: :created
        else
          render json: {
            errors: comment.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find_by(id: session[:user_id])
        unless user
          return render json: {
            message: "Please login first"
          }, status: :unauthorized
        end

        comment = user.comments.find_by(id: params[:id])

        unless comment
          return render json: {
            message: "Comment does not exists"
          }, status: :not_found
        end

        if comment.destroy
          render json: {
            message: "Delete Successfully"
          }, status: :ok
        else
          render json: {
            errors: comment.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private
      def comment_params
        params.permit(:post_id, :body, :parent_id)
      end
    end
  end
end