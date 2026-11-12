class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post

  def self.ransackable_attributes(auth_object = nil)
    ["id", "user_id", "post_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "post"]
  end
end
