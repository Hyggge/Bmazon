class Param < ApplicationRecord
  validates :name, presence: true

  belongs_to :commodity
end
