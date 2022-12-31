class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options do |t|
      t.string :description, precision: 10, scale: 2
      t.decimal :add

      t.timestamps
    end
  end
end
