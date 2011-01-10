class UserMailer < ActionMailer::Base
  def forgot_password(email, login, password)
    setup_email(email)
    @body[:email] = email
    @body[:login] = login
    @body[:password] = password
    @subject << 'Forgot Password'
    @body[:url] = "pgtracker.heroku.com"
  end
  
  def birthday_notification(to_email, bdays)
    @recipients = "#{Trojans::EMAIL}"
    @from = "Trojans <#{Trojans::FROM_EMAIL}>"
    @reply_to = "To <#{Trojans::FROM_EMAIL}>"
    @subject = "Happy Birthday"
    @sent_on = Time.now
    @body[:user] = to_email
    @body[:bdays] = bdays
  end

  protected

  def setup_email(email)
    @recipients = "#{email}"
    @from = "PGTracker <#{PGTracker::FROM_EMAIL}>"
    @reply_to = "To <#{PGTracker::FROM_EMAIL}>"
    @subject = "PGTracker - "
    @sent_on = Time.now    
  end

end