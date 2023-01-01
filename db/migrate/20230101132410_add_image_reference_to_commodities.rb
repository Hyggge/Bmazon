class AddImageReferenceToCommodities < ActiveRecord::Migration[7.0]
  def change
    add_reference :commodities, :image, null: false, foreign_key: true
  end
end
