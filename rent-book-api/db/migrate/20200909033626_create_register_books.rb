class CreateRegisterBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :register_books do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :intended_end_date

      t.timestamps
    end
  end
end
