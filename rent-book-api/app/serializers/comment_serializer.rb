class CommentSerializer < ActiveModel::Serializer
  type :comment
  attributes :id, :content, :created_at

  def created_at
    I18n.l(object.created_at, format: :date_month_year_concise)
  end
end
