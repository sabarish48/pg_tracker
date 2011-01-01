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
  
  def sort_th_class_helper(param)
    result = 'class="sortup"' if params[:sort] == param
    result = 'class="sortdown"' if params[:sort] == param + "_reverse"
    return result || 'class="sortup"'
  end
  
  def sort_link_helper(text, param)
    key = param
    key += "_reverse" if params[:sort] == param
    options = {
      :url => {:action => 'index', :params => params.merge({:sort => key, :page => nil})}
    }
    html_options = {
      :title => "Sort by this field",
      :href => url_for(:action => 'index', :params => params.merge({:sort => key, :page => nil}))
    }
    link_to_remote(text, options, html_options)
  end
    
  def string_truncate(text, length = 30, truncate_string = "... ")
    return (text.length > length) ? (text[0..(length-1)] + truncate_string) : text
  end

end

class Numeric
  def round_to(decimals = 0)
    factor = 10.0**decimals
    (self*factor).round / factor
  end
end