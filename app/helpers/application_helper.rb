# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Return a link for use in layout navigation.
  def nav_link(text, controller, action="index")
    link_to_unless_current text, :controller => controller,
      :action => action
  end

  # Return true if some user is logged in, false otherwise.
  def logged_in?
    not session[:user_id].nil?
  end

  # Invokes JavaScript for initializing our calendar JS module.
  def initialize_calendar
    javascript_tag "setTimeout('Calendar.initCalendar()', 250);"
  end

end
