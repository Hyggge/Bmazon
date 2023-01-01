class CreateOrderOptionMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :order_option_maps do |t|
      t.references :order, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
