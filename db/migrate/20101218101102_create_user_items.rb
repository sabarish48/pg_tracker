class CreateUserItems < ActiveRecord::Migration
  def self.up
    create_table :user_items do |t|
      t.column :item_id, :integer, :references => :items
      t.column :user_id,  :integer, :references => :users
      t.column :amount,  :float
      t.timestamps
    end
  end

  def self.down
    drop_table :user_items
  end
end
