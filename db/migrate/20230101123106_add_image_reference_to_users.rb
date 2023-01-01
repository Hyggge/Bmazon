class AddImageReferenceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :image, foreign_key: true
  end
end
