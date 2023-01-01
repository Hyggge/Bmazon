class Comment < ApplicationRecord
  validates :grade, presence: true, numericality: { in: 1..5 }
  validates :content, presence: true

  belongs_to :order

end
