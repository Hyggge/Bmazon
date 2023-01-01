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

  has_one :shop, class_name: "Shop", foreign_key: :owner_id


end
