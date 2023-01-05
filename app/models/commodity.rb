class Commodity < ApplicationRecord
  include Filterable
  include Sortable

  validates :name, presence: true
  validates :status, presence: true, numericality: { in: 0..3 }
  validates :total, presence: true
  validates :sale, presence: true
  validates :price, presence: true
  validates :method, presence: true , numericality: { in: 0..2 }

  belongs_to :shop
  belongs_to :image

  has_many :orders, dependent: :delete_all

  has_many :collects, dependent: :delete_all
  has_many :collectors, through: :collects, source: :user

  has_many :params, dependent: :delete_all

  has_many :relative_articles, class_name: "Article", foreign_key: :commodity_id, dependent: :delete_all

  # scope
  scope :filter_by_min_price, -> (query) { where(price: query..) }
  scope :filter_by_max_price, -> (query) { where(price: ..query) }
  scope :filter_by_status_exact, -> (query) { where(status: query) }
  scope :filter_by_method_exact, -> (query) { where(method: query) }

  scope :order_by_price_asc, -> { order(price: :asc) }
  scope :order_by_price_desc, -> { order(price: :desc) }
  scope :order_by_sale_asc, -> { order(sale: :asc) }
  scope :order_by_sale_desc, -> { order(sale: :desc) }


end
