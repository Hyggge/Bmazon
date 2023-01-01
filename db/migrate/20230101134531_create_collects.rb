class CreateCollects < ActiveRecord::Migration[7.0]
  def change
    create_table :collects do |t|
      t.references :commodity, null: true, foreign_key: true
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
