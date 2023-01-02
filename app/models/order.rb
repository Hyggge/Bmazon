class Order < ApplicationRecord
  # choices of `status`
  CREATED = 0
  PAID = 1
  DELIVERED = 2
  CONFIRMED = 3
  COMMENTED = 4
  CLOSED = 5

  validates :status, presence: true, numericality: { in: 0..5 }
  validates :price, presence: true
  validates :num, presence: true

  has_one :comment, dependent: :delete

  belongs_to :commodity
  belongs_to :user

  has_many :order_option_maps, dependent: :delete_all
  has_many :options, through: :order_option_maps, source: :option




end
