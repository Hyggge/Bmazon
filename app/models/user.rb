class User < ApplicationRecord
  include Filterable
  include Sortable

  has_secure_password

  # choices of `role`
  NORMAL_ROLE = 1
  ADMIN_ROLE = 0

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, numericality: { in: 0..1 }

  belongs_to :image, optional: true
  belongs_to :student, optional: true

  has_many :owning_shops, class_name: "Shop", foreign_key: :owner_id, dependent: :delete_all

  has_many :shop_managements, dependent: :delete_all
  has_many :managing_shops, through: :shop_managements, source: :shop

  has_many :orders, dependent: :delete_all

  has_many :collects, dependent: :delete_all
  has_many :collecting_commodities, through: :collects, source: :commodity

  has_many :written_articles, class_name: "Article", foreign_key: :author_id, dependent: :delete_all

  has_many :written_replies, class_name: "Reply", foreign_key: :user_id, dependent: :delete_all

  # scope
  scope :filter_by_id_exact, -> (query) { where(id: query) }
  scope :filter_by_username_fuzzy, -> (query) { where("username LIKE ?", "%#{query}%") }
  scope :filter_by_email_fuzzy, -> (query) { where("email LIKE ?", "%#{query}%")}
  scope :filter_by_phone_no_fuzzy, -> (query) { where("phone_no LIKE ?", "%#{query}%")}
  scope :filter_by_reg_date, -> (query) { where(created_at: Time.parse(query)..(Time.parse(query) + 24.hours)) }
  scope :order_by_id_asc, -> { order(:id => :asc) }
  scope :order_by_id_desc, ->  { order(:id => :desc) }


end
