class BookSerializer < ActiveModel::Serializer
  type :book
  attributes :id, :title, :description, :image, :author, :quantity, :rent_cost, :created_at, :updated_at

  def created_at
    I18n.l(object.created_at, format: :date_month_year_concise)
  end

  def updated_at
    I18n.l(object.updated_at, format: :date_month_year_concise)
  end
end
