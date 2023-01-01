class AddOrderReferenceToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :order, null: false, foreign_key: true
  end
end
