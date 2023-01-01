class AddReferReferenceToReplies < ActiveRecord::Migration[7.0]
  def change
    add_reference :replies, :refer, foreign_key: {to_table: :replies}
  end
end
