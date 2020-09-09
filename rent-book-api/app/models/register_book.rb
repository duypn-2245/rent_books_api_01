class RegisterBook < ApplicationRecord
  has_many :register_book_details, dependent: :destroy, index_errors: true
  has_many :register_book_details, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :register_book_details

  enum status: {pending: 0, approved: 1, rejected: 2, finished: 3, canceled: 4}
  validates :intended_end_date, presence: true
  validates :start_date, presence: true
  validate :start_intended_end_date, if: ->{start_date.present? && intended_end_date.present?}
  validate :start_end_date, if: ->{start_date.present? && end_date.present?}
  validate :check_start_date, if: ->{start_date.present?}, on: :create

  scope :recent, ->{order created_at: :desc}

  def check_start_date
    return if start_date >= Time.zone.today

    errors.add :start_date, I18n.t("activerecord.errors.models.register_book.attributes.start_date.invalid_date_now")
  end

  def start_intended_end_date
    return if start_date <= intended_end_date

    errors.add(:intended_end_date,
               I18n.t("activerecord.errors.models.register_book.attributes.intended_end_date.greater_start"))
  end

  def start_end_date
    return if start_date <= end_date

    errors.add :end_date, I18n.t("activerecord.errors.models.register_book.attributes.end_date.greater_start")
  end
end
