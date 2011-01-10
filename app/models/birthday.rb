class Birthday < ActiveRecord::Base

  def self.send_birthday_notification
    birthdays = Array.new
    puts "hello checking"
    Birthday.find(:all).each do |user|
      dob = user.date_of_birth
      if dob.day == Time.now.day && dob.month == Time.now.month
        puts "hello working #{user.name}"
        birthdays << user
      end
    end
    UserMailer.deliver_birthday_notification(Trojans::EMAIL, birthdays) if !birthdays.empty?
  end

end