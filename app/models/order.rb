class Order < ApplicationRecord
  include Filterable
  include Sortable

  # choices of `status`
  CREATED = 0
  PAID = 1
  DELIVERED = 2
  CONFIRMED = 3
  COMMENTED = 4
  CLOSED = 5

  validates :status, presence: true, numericality: { in: 0..5 }
  validates :price, presence: true
  validates :num, presence: true

  has_one :comment, dependent: :delete

  belongs_to :commodity
  belongs_to :user

  has_many :order_option_maps, dependent: :delete_all
  has_many :options, through: :order_option_maps, source: :option

  # scope
  scope :filter_by_id_exact, -> (query) { where(id: query) }
  scope :filter_by_num_exact, -> (query) { where(num: query) }
  scope :filter_by_price_exact, -> (query) { where(price: query) }
  scope :filter_by_status_exact, -> (query) { where(status: query) }
  scope :filter_by_commodity_name_fuzzy, -> (query) {
    res = find_by_sql("
        SELECT orders.* FROM orders
        INNER JOIN commodities ON orders.commodity_id = commodities.id
        WHERE commodities.name LIKE '%#{query}%'
    ")
    self.where(id: res.map(&:id))
  }
  scope :filter_by_shop_name_fuzzy, -> (query) {
    res = find_by_sql("
        SELECT orders.* FROM orders
        INNER JOIN commodities on orders.commodity_id = commodities.id
        INNER JOIN shops on commodities.shop_id = shops.id
        WHERE shops.name LIKE '%#{query}%'
    ")
    self.where(id: res.map(&:id))
  }
  scope :filter_by_username_fuzzy, -> (query) {
    res = find_by_sql("
        SELECT orders.* FROM orders
        INNER JOIN users ON orders.user_id = users.id
        WHERE users.username LIKE '%#{query}%'
    ")
    self.where(id: res.map(&:id))
  }
  scope :filter_by_create_date, -> (query) { where(created_at: Time.parse(query)..(Time.parse(query) + 24.hours)) }

  scope :order_by_id_asc, -> { order(:id => :asc) }
  scope :order_by_id_desc, ->  { order(:id => :desc) }
  scope :order_by_num_asc, -> { order(:num => :asc) }
  scope :order_by_num_desc, ->  { order(:num => :desc) }
  scope :order_by_price_asc, -> { order(:price => :asc) }
  scope :order_by_price_desc, ->  { order(:price => :desc) }
  scope :order_by_create_time_asc, -> { order(:created_at => :asc) }
  scope :order_by_create_time_desc, ->  { order(:created_at => :desc) }


end
