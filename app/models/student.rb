class Student < ApplicationRecord
  validates :name, presence: true
  validates :depart, presence: true
  validates :attendance_year, presence: true
  validates :gender, presence: true, numericality: { in: 0..1 }

  has_one :user

  belongs_to :image

end
