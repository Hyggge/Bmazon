class Article < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  belongs_to :commodity
  belongs_to :author, class_name: "User", foreign_key: :author_id

end
