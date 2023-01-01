class Order < ApplicationRecord
  validates :status, presence: true, numericality: { in: 0..5 }
  validates :price, presence: true
  validates :num, presence: true

  has_many :comments, dependent: delete_all

end
