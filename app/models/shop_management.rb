class ShopManagement < ApplicationRecord
  validates :shop_id, null: false
  validates :user_id, null: false

  belongs_to :user
  belongs_to :shop

end
