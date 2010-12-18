class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.column :name, :string
      t.column :user_id,  :integer
      t.column :amount, :float
      t.column :transaction_date, :date
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
