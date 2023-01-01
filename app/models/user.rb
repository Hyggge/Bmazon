class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, numericality: { in: 0..1 }

  belongs_to :image
  belongs_to :student

  has_many :owning_shops, class_name: "Shop", foreign_key: :owner_id, dependent: :delete_all

  has_many :shop_managements, dependent: :delete_all
  has_many :managing_shops, through: :shop_managements, source: :shop

  has_many :orders, dependent: :delete_all

  has_many :collects, dependent: :delete_all
  has_many :collecting_commodities, through: :collects, source: :commodity

end
