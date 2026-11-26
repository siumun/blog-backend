class Post < ApplicationRecord
  before_validation :generate_slug
  before_validation :set_publication_date, if: :publishing_now?

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :body, presence: true
  validates :excerpt, presence: true
  validates :publication_date, presence: true, if: :published?
  validates :status, presence: true
  validate :publication_date_cannot_be_in_the_past

  belongs_to :admin_user
  has_many :favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_one_attached :top_image
  has_many :comments, dependent: :destroy
  
  enum :status, {
    draft: 0,
    published: 1
  }

  def top_image_url
    if top_image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(
        top_image,
        # host: ENV.fetch("APP_HOST"),
        # protocol: "https"
        host: "localhost:3000",
        protocol: "http"
      )
    end
  end

  def publish_if_due
    return unless status == "draft"
    return unless publication_date.present?
    return if publication_date > Time.current

    update(status: "published")
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

  def publishing_now?
      will_save_change_to_status? && published?
  end

  def set_publication_date
    self.publication_date = Time.current
  end


  def publication_date_cannot_be_in_the_past
    return if publication_date.blank?
    return if published?

    if publication_date < Time.current
      errors.add(:publication_date, "cannot be in the past")
    end
  end

end
