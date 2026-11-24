class PublishScheduledPostsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Post.where(status: "draft")
	.where("publication_date <= ?", Time.current)
	.find_each do |post|
	post.publish_if_due
   end
  end
end
