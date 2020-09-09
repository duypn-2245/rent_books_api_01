class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.text :image
      t.string :author
      t.integer :quantity
      t.float :rent_cost

      t.timestamps
    end
  end
end
