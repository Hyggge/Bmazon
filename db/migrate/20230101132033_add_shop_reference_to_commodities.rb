class AddShopReferenceToCommodities < ActiveRecord::Migration[7.0]
  def change
    add_reference :commodities, :shop, null: false, foreign_key: true
  end
end
