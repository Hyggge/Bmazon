class Student < ApplicationRecord
  validates :name, presence: true
  validates :depart, presence: true
  validates :attendance_year, presence: true
  validates :gender, presence: true, numericality: { in: 0..1 }

  has_one :user

  belongs_to :image

  # scope
  scope :filter_by_student_id_fuzzy, -> (query) { where("id LIKE ?", "%#{query}%") }
  scope :filter_by_student_name_fuzzy, -> (query) { where("name LIKE ?", "%#{query}%") }
  scope :filter_by_depart_exact, -> (query) { where(depart: query)}
  scope :filter_by_user_id_exact, -> (query) { joins(:user).where(user: {id: query}) }
  scope :filter_by_username_fuzzy, -> (query) {
    # joins(:owner => :student).where("student.id LIKE ?", "%#{query}%")
    find_by_sql("
        SELECT * FROM students
        INNER JOIN users ON students.id = users.student_id
        WHERE users.username LIKE '%#{query}%'
    ")
  }
  scope :filter_by_reg_date, -> (query) { where(created_at: Time.parse(query)..(Time.parse(query) + 24.hours)) }
  scope :order_by_student_id_asc, -> { order(:id => :asc) }
  scope :order_by_student_id_desc, ->  { order(:id => :desc) }


end
