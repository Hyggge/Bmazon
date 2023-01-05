class Shop < ApplicationRecord
  self.inheritance_column = :_type_disabled
  include Filterable
  include Sortable

  validates :name, presence: true
  validates :type, presence: true, numericality: { in: 0..1 }

  belongs_to :image, optional: true
  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  has_many :shop_managements, dependent: :delete_all
  has_many :managers, through: :shop_managements, source: :user

  has_many :commodities, dependent: :delete_all


  # scope
  scope :filter_by_id_exact, -> (query) { where(id: query) }
  scope :filter_by_name_fuzzy, -> (query) { where("name LIKE ?", "%#{query}%") }
  scope :filter_by_type_exact, -> (query) { where(type: query) }
  scope :filter_by_student_id_fuzzy, -> (query) {
    # joins(:owner => :student).where("student.id LIKE ?", "%#{query}%")
    find_by_sql("
        SELECT * FROM shops
        INNER JOIN users ON users.id = shops.owner_id
        INNER JOIN students ON students.id = users.student_id
        WHERE students.id LIKE '%#{query}%'
    ")
  }
  scope :filter_by_student_name_fuzzy, -> (query) {
    # joins(:owner => :student).where("student.id LIKE ?", "%#{query}%")
    find_by_sql("
        SELECT * FROM shops
        INNER JOIN users ON users.id = shops.owner_id
        INNER JOIN students ON students.id = users.student_id
        WHERE students.name LIKE '%#{query}%'
    ")
  }
  scope :filter_by_reg_date, -> (query) { where(created_at: Time.parse(query)..(Time.parse(query) + 24.hours)) }
  scope :order_by_id_asc, -> { order(:id => :asc) }
  scope :order_by_id_desc, ->  { order(:id => :desc) }



end
