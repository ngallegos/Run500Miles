class ChangeDataTypeForActivityActivityType < ActiveRecord::Migration[4.2]
  def self.up
    change_table :activities do |t|
	  t.change :activity_type, :integer
	end
  end

  def self.down
    change_table :activities do |t|
	  t.change :activity_type, :string
	end
  end
end
