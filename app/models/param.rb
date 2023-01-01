class Param < ApplicationRecord
  validates :name, presence: true

  belongs_to :commodity

  has_many :options, dependent: :delete_all

end
