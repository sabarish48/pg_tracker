require 'digest/sha1'
class Item < ActiveRecord::Base
  # Max & min lengths for all fields
  NAME_MIN_LENGTH = 4
  NAME_MAX_LENGTH = 50
  NAME_RANGE = NAME_MIN_LENGTH..NAME_MAX_LENGTH
  # Text box sizes for display in the views
  NAME_SIZE = 20
  attr_accessor :remember_me
  attr_accessor :current_password    
  validates_length_of :name, :within => NAME_RANGE  
  validates_presence_of :user_id
  validates_presence_of :amount
  validates_presence_of :transaction_date

  def validate
    errors.add(:amount, "must be valid.") unless amount > 0    
  end
end
