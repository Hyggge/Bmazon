class Reply < ApplicationRecord
  validates :floor, presence: true
  validates :content, presence: true

  belongs_to :article
  belongs_to :referred_reply, class_name: "Reply", foreign_key: :refer_id
  belongs_to :user

  has_many :replies, class_name: "Reply", foreign_key: :refer_id, dependent: :delete_all

end
