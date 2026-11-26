class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post


  validates :body, presence: true
  validates :user, presence: true
  validates :post, presence: true

  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy


end
