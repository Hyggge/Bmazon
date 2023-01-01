class AddCommodityReferenceToParams < ActiveRecord::Migration[7.0]
  def change
    add_reference :params, :commodity, null: false, foreign_key: true
  end
end
