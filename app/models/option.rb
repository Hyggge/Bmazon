class Option < ApplicationRecord
  validates :description, presence: true
  validates :add, presence: true

  belongs_to :param

  has_many :order_option_maps, dependent: :delete_all
  has_many :orders, through: :order_option_maps, source: :order

end
