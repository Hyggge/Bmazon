class Article < ApplicationRecord
  include Filterable
  include Sortable


  validates :title, presence: true
  validates :content, presence: true

  belongs_to :commodity, optional: true
  belongs_to :author, class_name: "User", foreign_key: :author_id

  has_many :replies, dependent: :delete_all

  # scope
  scope :filter_by_start_date, -> (query) { where(created_at: Time.parse(query).. ) }
  # 另一种写法： scope :filter_by_start_time, -> (query) { where("created_at >= ?", Time.parse(query) ) }
  scope :filter_by_end_date, -> (query) { where(created_at: ..(Time.parse(query) + 24.hours) ) }
  # 另一种写法： scope :filter_by_start_time, -> (query) { where("created_at <= ?", Time.parse(query) ) }
  scope :order_by_create_time_asc, -> { order(created_at: :asc) }
  scope :order_by_create_time_desc, -> { order(created_at: :desc) }


end
