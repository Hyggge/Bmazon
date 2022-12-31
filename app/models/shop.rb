class Shop < ApplicationRecord
  validates :name, presence: true
  validates :type, presence: true, numericality: { in: 0..1 }
end
