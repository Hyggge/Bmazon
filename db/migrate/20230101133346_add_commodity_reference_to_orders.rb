class AddCommodityReferenceToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :commodity, null:false, foreign_key: true
  end
end
