class Commodity < ApplicationRecord
  validates :name, presence: true
  validates :status, presence: true, numericality: { in: 0..3 }
  validates :total, presence: true
  validates :sale, presence: true
  validates :price, presence: true
  validates :method, presence: true , numericality: { in: 0..2 }

  belongs_to :shop
  belongs_to :image

end
