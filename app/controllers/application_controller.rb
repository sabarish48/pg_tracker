# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ApplicationHelper
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :check_authorization

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_rails_space_session_id'

  # Log a user in by authorization cookie if necessary.
  def check_authorization
    authorization_token = cookies[:authorization_token]
    if authorization_token and not logged_in?
      user = User.find_by_authorization_token(authorization_token)
      user.log_in!(session) if user
    end
  end
  

end
