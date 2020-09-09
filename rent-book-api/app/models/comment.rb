class Comment < ApplicationRecord
  has_many :replies, class_name: Comment.name, foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: Comment.name, optional: true
  belongs_to :user
  belongs_to :book

  validates :content, presence: true,
                      length: {maximum: Settings.comment.content.maximum}
end
