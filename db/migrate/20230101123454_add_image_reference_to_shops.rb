class AddImageReferenceToShops < ActiveRecord::Migration[7.0]
  def change
    add_reference :shops, :image, foreign_key: true
  end
end
