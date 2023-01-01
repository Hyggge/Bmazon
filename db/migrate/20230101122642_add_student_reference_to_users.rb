class AddStudentReferenceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :student, foreign_key: { to_table: :students }
  end
end
