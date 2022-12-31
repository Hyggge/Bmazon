class Reply < ApplicationRecord
  validates :floor, presence: true
  validates :content, presence: true
end
