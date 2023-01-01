class AddStudentReferenceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :student, foreign_keys: { to_table: :students }
  end
end
