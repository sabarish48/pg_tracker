desc "Send notifications on the birthdays of the list"
task :cron => :environment do
 #if Time.now.hour == 0 # run at midnight
   Birthday.send_birthday_notification
 #end
end
