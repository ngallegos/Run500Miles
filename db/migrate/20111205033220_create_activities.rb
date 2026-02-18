class CreateActivities < ActiveRecord::Migration[4.2]
  def self.up
    create_table :activities do |t|
      t.string :comment
      t.integer :user_id
      t.date :activity_date
      t.float :distance
      t.integer :hours
      t.integer :minutes

      t.timestamps
    end
    add_index :activities, [:user_id, :created_at]
  end

  def self.down
    drop_table :activities
  end
end
