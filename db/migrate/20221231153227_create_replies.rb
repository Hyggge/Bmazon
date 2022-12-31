class CreateReplies < ActiveRecord::Migration[7.0]
  def change
    create_table :replies do |t|
      t.integer :floor
      t.string :content

      t.timestamps
    end
  end
end
