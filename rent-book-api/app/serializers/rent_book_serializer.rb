class RentBookSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :rent_cost, :start_date, :end_date, :intended_end_date

  def start_date
    I18n.l(object.start_date, format: :date_month_year_concise)
  end

  def end_date
    return if object.end_date.blank?

    I18n.l(object.end_date, format: :date_month_year_concise)
  end

  def intended_end_date
    I18n.l(object.intended_end_date, format: :date_month_year_concise)
  end
end
