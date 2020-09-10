class CreateRegisterBookDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :register_book_details do |t|
      t.references :book, null: false, foreign_key: true
      t.references :register_book, null: false, foreign_key: true
      t.integer :quantity
      t.float :rent_cost

      t.timestamps
    end
  end
end
