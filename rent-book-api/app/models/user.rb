class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :register_books, dependent: :destroy

  enum role: {admin: 0, user: 1}
  validates :name, presence: true, length: {maximum: Settings.user.name.maximum}
  validates :email, presence: true,
                    length: {maximum: Settings.user.email.maximum},
                    format: {with: Settings.user.email.valid},
                    uniqueness: true
  validates :password_digest, presence: true,
                       length: {minimum: Settings.user.password.minimum}

  before_save :downcase_email

  devise :database_authenticatable, :registerable, :validatable

  private

  def downcase_email
    email.downcase!
  end
end
