class AddUserTypeIndex < ActiveRecord::Migration[4.2]
  def self.up
    add_index :users, :user_type
  end

  def self.down
    remove_index :users, :user_type
  end
end
