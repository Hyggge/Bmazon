class AddIsDeletedColumnToReplies < ActiveRecord::Migration[7.0]
  def change
    change_table :replies do |t|
      t.integer :is_deleted
    end
  end
end
