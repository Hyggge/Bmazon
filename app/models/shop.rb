class Shop < ApplicationRecord
  validates :name, presence: true
  validates :type, presence: true, numericality: { in: 0..1 }

  belongs_to :image
  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  has_many :shop_managements, dependent: :delete_all
  has_many :managers, through: :shop_managements, source: :user

  has_many :commodities, dependent: :delete_all

end
