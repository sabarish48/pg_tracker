class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.column :name, :string
      t.column :user_id,  :integer
      t.column :amount, :float
      t.column :expense_date, :date
      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
