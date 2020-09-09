class RegisterBook < ApplicationRecord
  belongs_to :user

  enum status: {pending: 0, approved: 1, rejected: 2, finished: 3, canceled: 4}
  validates :intended_end_date, presence: true
  validates :start_date, presence: true
end
