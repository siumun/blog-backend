class Tag < ApplicationRecord
  before_validation :generate_slug
  
  has_many :post_tags
  has_many :posts, through: :post_tags

  validates :name, presence: true, uniqueness: true

  private
  def generate_slug
    self.slug = name.parameterize if name.present?
  end

end
