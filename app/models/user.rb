require 'digest/sha1'
class User < ActiveRecord::Base
  # Max & min lengths for all fields
  SCREEN_NAME_MIN_LENGTH = 4
  SCREEN_NAME_MAX_LENGTH = 20  
  PASSWORD_MIN_LENGTH = 4
  PASSWORD_MAX_LENGTH = 40
  EMAIL_MAX_LENGTH = 50
  SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
  # Text box sizes for display in the views
  SCREEN_NAME_SIZE = 20
  PASSWORD_SIZE = 10
  EMAIL_SIZE = 30
  attr_accessor :remember_me
  attr_accessor :current_password
  validates_uniqueness_of :screen_name, :email
  validates_confirmation_of :password
  validates_length_of :screen_name, :within => SCREEN_NAME_RANGE
  validates_length_of :password, :within => PASSWORD_RANGE
  validates_presence_of :email, :password, :password_confirmation, :salt
  validates_length_of :email, :maximum => EMAIL_MAX_LENGTH
  validates_format_of :screen_name,
    :with => /^[A-Z0-9_]*$/i,
    :message => "must contain only letters, " +
    "numbers, and underscores"
  validates_format_of :email,
    :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
    :message => "must be a valid email address"
  attr_protected :id, :salt
  attr_accessor :password, :password_confirmation
  has_many :items, :dependent => :destroy  

  def validate
    errors.add(:email, "must be valid.") unless email.include?("@")
    if screen_name.include?(" ")
      errors.add(:screen_name, "cannot include spaces.")
    end
  end

  # Log a user in.
  def login!(session)
    session[:user_id] = self.id
  end

  # Log a user out.
  def self.logout!(session, cookies)
    session[:user_id] = nil
    cookies.delete(:authorization_token)
  end

  # Clear the password (typically to suppress its display in a view).
  def clear_password!
    self.password = nil
    self.password_confirmation = nil
    self.current_password = nil
  end

  
  # Remember a user for future login.
  def remember!(cookies)
    cookie_expiration = 10.years.from_now
    cookies[:remember_me] = { :value   => "1",
      :expires => cookie_expiration }
    self.authorization_token = unique_identifier
    save!
    cookies[:authorization_token] = { :value   => authorization_token,
      :expires => cookie_expiration }
  end

  # Forget a user's login status.
  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
  end
  # Return true if the user wants the login status remembered.
  def remember_me?
    remember_me == "1"
  end

  # Return true if the password from params is correct.
  def correct_password?(params)
    current_password = params[:user][:current_password]
    password == current_password
  end

  def password_errors(params)
    # Use User model's valid? method to generate error messages
    # for a password mismatch (if any).
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    valid?
    # The current password is incorrect, so add an error message.
    errors.add(:current_password, "is incorrect")
  end
  
  def password=(pass)
    @password=pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)    
  end
  
  def self.authenticate(screen_name, password)
    u=find(:first, :conditions=>["screen_name = ?", screen_name])
    return nil if u.nil?
    return u if User.encrypt(password, u.salt|| 'wxyz') == u.hashed_password
    nil
  end

  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save    
    UserMailer.deliver_forgot_password(self.email, self.screen_name, new_pass)
  end

  protected
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  private
  # Generate a unique identifier for a user.
  def unique_identifier
    Digest::SHA1.hexdigest("#{screen_name}:#{password}")
  end

end
