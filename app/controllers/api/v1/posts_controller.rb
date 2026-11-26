module Api
  module V1
    class PostsController< ApplicationController
      def index
        Rails.logger.info "CHECKPOINT 1: index started"

        per_page = 10
        cursor_date = params[:cursor_date]
        cursor_id = params[:cursor_id]

        @posts = Post.where(status: :published)
                    .order(publication_date: :desc, id: :desc)
        Rails.logger.info "CHECKPOINT 2: relation created"

        if cursor_date.present? && cursor_id.present?
          @posts = @posts.where(
            "publication_date < ? OR (publication_date = ? AND id < ?)",
            cursor_date,
            cursor_date,
            cursor_id
          )
        end

        posts = @posts.limit(per_page + 1).to_a #to array
        has_more = posts.length > per_page

        Rails.logger.info "CHECKPOINT 3: posts loaded"

        posts = posts.first(per_page)

        next_cursor = if has_more && posts.any?
          {
            cursor_date: posts.last.publication_date,
            cursor_id: posts.last.id
          }
        else
          nil
        end

        render json: {
          posts: posts.as_json(
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
        next_cursor: next_cursor,
        has_more: has_more
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
