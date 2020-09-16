class CommentSerializer < ActiveModel::Serializer
  type :comment
  attributes :id, :content, :parent_id, :user_id, :created_at, :updated_at

  def created_at
    I18n.l(object.created_at, format: :date_month_year_concise)
  end

  def updated_at
    I18n.l(object.updated_at, format: :date_month_year_concise)
  end
end
