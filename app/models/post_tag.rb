class PostTag < ApplicationRecord
  belongs_to :post
  belongs_to :tag

  def self.ransackable_attributes(auth_object = nil)
    ["id", "post_id", "tag_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["post", "tag"]
  end
end