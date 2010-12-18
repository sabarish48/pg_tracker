class AddTypeToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :type, :integer
  end

  def self.down
    remove_column :items, :type
  end
end
