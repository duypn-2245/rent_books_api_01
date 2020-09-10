class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.string :trackable_type
      t.integer :trackable_id
      t.string :owner_type
      t.integer :owner_id
      t.string :key
      t.text :parameter
      t.string :recipient_type
      t.integer :recipient_id
      t.boolean :read

      t.timestamps
    end
  end
end
