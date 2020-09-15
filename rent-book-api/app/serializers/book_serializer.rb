class BookSerializer < ActiveModel::Serializer
  attributes :title, :description, :image, :author, :quantity, :rent_cost
end
