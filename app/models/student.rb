class Student < ApplicationRecord
  include Filterable
  include Sortable


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
    res = find_by_sql("
        SELECT students.* FROM students
        INNER JOIN users ON students.id = users.student_id
        WHERE users.username LIKE '%#{query}%'
    ")
    self.where(id: res.map(&:id))
  }
  scope :filter_by_reg_date, -> (query) { where(created_at: Time.parse(query)..(Time.parse(query) + 24.hours)) }
  scope :order_by_student_id_asc, -> { order(:id => :asc) }
  scope :order_by_student_id_desc, ->  { order(:id => :desc) }
  scope :order_by_user_id_asc, -> {
    res = find_by_sql("
       SELECT id FROM
       (SELECT students.id AS id, users.id AS user_id from students
       INNER JOIN users ON students.id = users.student_id
       ORDER BY user_id ASC)
    ")
    # where筛选后默认id升序，为了保证where筛选后的结果仍然按照res的顺序排列，我们需要手动对筛选结果进行sort
    self.where(id: res.map(&:id)).sort_by {|x| res.map(&:id).index(x.id)} => array
    # self.where(id: res.map(&:id)).order("field(id,#{res.map(&:id).join(",")})")
  }
  scope :order_by_user_id_desc, ->  {
    res = find_by_sql("
       SELECT id FROM
       (SELECT students.id AS id, users.id AS user_id from students
       INNER JOIN users ON students.id = users.student_id
       ORDER BY user_id DESC)
    ")
    self.where(id: res.map(&:id)).sort_by {|x| res.map(&:id).index(x.id)}
  }


end
