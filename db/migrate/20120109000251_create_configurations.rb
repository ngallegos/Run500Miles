class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
  end

  def self.down
    drop_table :configurations
  end
end
