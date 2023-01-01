class AddParamReferenceToOptions < ActiveRecord::Migration[7.0]
  def change
    add_reference :options, :param, null: false, foreign_key: true
  end
end
