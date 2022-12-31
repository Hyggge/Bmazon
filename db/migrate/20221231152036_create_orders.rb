class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :status
      t.decimal :price, precision: 10, scale: 2
      t.integer :num
      t.string :address
      t.text :note
      t.datetime :pay_time
      t.datetime :confirm_time
      t.datetime :close_time
      t.datetime :deliver_time

      t.timestamps
    end
  end
end
