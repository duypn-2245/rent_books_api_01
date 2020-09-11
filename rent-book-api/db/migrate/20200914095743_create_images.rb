class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.integer :imagetable_id
      t.string :imagetable_type
      t.string :photo
      t.timestamps
    end
  end
end
