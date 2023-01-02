class ShopManagement < ApplicationRecord
  validates :shop_id, presence: false
  validates :user_id, presence: false

  belongs_to :user
  belongs_to :shop

end
