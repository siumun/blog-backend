class Post < ApplicationRecord
  before_validation :generate_slug

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :body, presence: true
  validates :excerpt, presence: true
  validates :publication_date, presence: true
  validates :status, presence: true


  belongs_to :admin_user
  has_many :favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_one_attached :top_image
  
  enum :status, {
    draft: 0,
    published: 1
  }

  # Ransack searchable attributes
  def self.ransackable_attributes(auth_object = nil)
    ["id", "title", "slug", "excerpt", "body",
     "publication_date", "status", "view_count", "created_at", "updated_at"]
  end

  # Ransack searchable associations
  def self.ransackable_associations(auth_object = nil)
    ["admin_user", "favorites", "post_tags", "tags"]
  end

  private
  def generate_slug
    return if title.blank?

    base_slug = title.parameterize
    self.slug = base_slug

    counter = 2

    while Post.where(slug: slug).where.not(id: id).exists?
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end
end
