class AddImageReferenceToShops < ActiveRecord::Migration[7.0]
  def change
    add_reference :shops, :image, foreign_keys: true
  end
end
