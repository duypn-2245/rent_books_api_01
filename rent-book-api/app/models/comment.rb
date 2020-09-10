class Comment < ApplicationRecord
  has_many :replies, class_name: "Comment", foreign_key: "parent_id"
  belongs_to :user
  belongs_to :book

  validates :content, presence: true,
                      length: {maximum: Settings.comment.content.maximum}
end
