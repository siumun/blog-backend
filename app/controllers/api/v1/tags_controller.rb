module Api
  module V1
    class TagsController <ApplicationController
      skip_forgery_protection
      def index
        @tags = Tag.all
        render json: @tags
      end

      def posts
        @tag = Tag.find_by(slug: params[:slug])

        unless @tag
          return render json: {
            message: "Tag not found"
          }, status: :not_found
        end

        posts = @tag.posts.where(status: "published").with_attached_top_image
        render json: {
          tag: @tag,
          posts: posts.as_json(
            methods: [:top_image_url],
            only: [:id, :title, :slug, :excerpt]
          )
        }
      end
    end
  end
end