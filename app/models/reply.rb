class Reply < ApplicationRecord
  validates :floor, presence: true
  validates :content, presence: true
  validates :is_deleted, presence: true, numericality: { in: 0..1 }

  belongs_to :article
  belongs_to :referring_reply, class_name: "Reply", foreign_key: :refer_id, optional: true
  belongs_to :user

  has_many :replies, class_name: "Reply", foreign_key: :refer_id, dependent: :delete_all

end
