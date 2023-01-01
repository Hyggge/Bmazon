class CreateShopManagements < ActiveRecord::Migration[7.0]
  def change
    create_table :shop_managements do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :user, null: false , foreign_key: true
      t.timestamps
    end
  end
end
