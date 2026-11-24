module Api
  module V1
    class PostsController< ApplicationController
      def index
        @posts = Post.where(status: :published)
                    .order(publication_date: :desc)

        render json: @posts.as_json(
          only: [
            :id,
            :title,
            :slug,
            :excerpt,
            :view_count,
            :publication_date
          ],
          methods: [:top_image_url]
        )
      end

      def show
        @post = Post.find_by!(slug: params[:slug])
        @post.increment!(:view_count)

        render json: {
          post: @post.as_json(
            include: {
              post_tags: {
                include:{
                  tag: {
                    only: [:id, :name, :slug]
                  }
                }
              }
            },
            methods: [:top_image_url]
          )
        }
      end

    end
  end
end
