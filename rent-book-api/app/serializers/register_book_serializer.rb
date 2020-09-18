class RegisterBookSerializer < ActiveModel::Serializer
  attributes :id, :status, :user_id, :intended_end_date, :start_date, :end_date, :created_at, :updated_at

  def intended_end_date
    I18n.l(object.intended_end_date, format: :date_month_year_concise)
  end

  def start_date
    I18n.l(object.start_date, format: :date_month_year_concise)
  end

  def end_date
    return if object.end_date.blank?

    I18n.l(object.end_date, format: :date_month_year_concise)
  end

  def created_at
    I18n.l(object.created_at, format: :date_month_year_concise)
  end

  def updated_at
    I18n.l(object.updated_at, format: :date_month_year_concise)
  end
end
