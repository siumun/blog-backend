module Api
  module V1
    class PostsController< ApplicationController
      def index
        per_page = params[:per_page].to_i
        per_page = 10 if per_page <1
        per_page =[per_page, 50].min

        page = params[:page].to_i
        page = 1 if page < 1

        published_posts = Post.where(status: :published)

        total_posts = published_posts.count
        total_pages = (total_posts.to_f / per_page).ceil


        @posts = Post.where(status: :published)
                    .order(publication_date: :desc, id: :desc)
                    .limit(per_page)
                    .offset((page-1) * per_page)

        render json: {
          posts: @posts.as_json(
            only: [
              :id,
              :title,
              :slug,
              :excerpt,
              :view_count,
              :publication_date
            ],
            methods: [:top_image_url]
          ),
          current_page: page,
          total_pages: total_pages,
          total_posts: total_posts
        }
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
