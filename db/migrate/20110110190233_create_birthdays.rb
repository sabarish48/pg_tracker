class CreateBirthdays < ActiveRecord::Migration
  def self.up
    create_table :birthdays do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.date :date_of_birth
      t.timestamps
    end
  end

  def self.down
    drop_table :birthdays
  end
end
