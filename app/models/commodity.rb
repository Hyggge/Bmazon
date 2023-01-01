class Commodity < ApplicationRecord
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


end
