class Option < ApplicationRecord
  validates :description, presence: true
  validates :add, presence: true
end
