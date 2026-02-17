class AddUserTypeToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :user_type, :string, :default => "2"
  end

  def self.down
    remove_column :users, :user_type
  end
end
