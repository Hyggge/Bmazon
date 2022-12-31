class CreateCommodities < ActiveRecord::Migration[7.0]
  def change
    create_table :commodities do |t|
      t.string :name
      t.text :introduction
      t.integer :status
      t.integer :total
      t.integer :sale
      t.decimal :price, precision: 10, scale: 2
      t.integer :method

      t.timestamps
    end
  end
end
