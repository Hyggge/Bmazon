class Image < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one_attached :image
  validates :image, presence: true

  def url
    url_for(image)
  end


end
