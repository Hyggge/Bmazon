class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.string :name
      t.text :introduction
      t.integer :type

      t.timestamps
    end
  end
end
