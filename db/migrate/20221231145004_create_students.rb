class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :name
      t.integer :depart
      t.integer :attendance_year
      t.integer :gender

      t.timestamps
    end
  end
end
