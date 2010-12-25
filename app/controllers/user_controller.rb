class UserController < ApplicationController
  include ApplicationHelper
  skip_before_filter :verify_authenticity_token
  before_filter :login_required, :only=>['welcome', 'change_password', 'hidden']
  #before_filter :protect, :only => [:index, :edit]

  def index
    unless session[:user_id]
      flash[:notice] = "Please log in first"
      redirect_to :action => "login"
      return
    end    
    @title = "PG Tracker User Hub"
    @user = User.find(session[:user_id])
    # This will be a protected page for viewing user information.
  end

  def login
    @title = "Log in to PG Tracker"
    if request.get?
      @user = User.new(:remember_me => remember_me_string)
    elsif param_posted?(:user)
      @user = User.new(params[:user])
      user = User.authenticate(@user.screen_name, @user.password)      
      if user
        user.login!(session)
        @user.remember_me? ? user.remember!(cookies) : user.forget!(cookies)
        flash[:notice] = "Welcome #{user.screen_name}!"
        redirect_to_forwarding_url
      else
        #@user.clear_password!
        flash[:notice] = "Invalid screen name/password combination"
      end
    end
  end
  
  def register
    @title = "Register"
    if param_posted?(:user)
      @user = User.new(params[:user])
      if @user.save
        session[:user] = User.authenticate(@user.screen_name, @user.password)
        @user.login!(session)
        flash[:notice] = "User #{@user.screen_name} created!"
        redirect_to_forwarding_url        
      else
        #@user.clear_password!
      end
    end
  end

  # Edit the user's basic info.
  def edit
    @title = "Edit Profile"
    @user = User.find(session[:user_id])
    if param_posted?(:user)
      attribute = params[:attribute]
      case attribute
      when "email"
        try_to_update @user, attribute
      when "password"
        @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])        
        if @user.save
          flash[:notice] = "User #{attribute} updated."
          redirect_to :action => "index"
        else
          @user.password_errors(params)
        end
      end
    end
    # For security purposes, never fill in password fields.
    #@user.clear_password!
  end

  def show
    @user = User.find(session[:user_id])
  end

  def logout
    User.logout!(session, cookies)
    flash[:notice] = "Logged out"
    redirect_to :action => "login", :controller => "user"
  end
  
  def forgot_password
    @title = "Forgot Password"    
    if request.post?
      user = User.find_by_email(params[:user][:email])
      if user and user.send_new_password
        flash[:notice]  = "A new password has been sent by email."
        redirect_to :action=>'login'
      else
        flash[:warning]  = "Couldn't send password"
      end
    end
  end

  def welcome
  end

  def hidden
  end

private
  # Protect a page from unauthorized access.
  def protect
    unless logged_in?
      session[:protected_page] = request.request_uri
      flash[:notice] = "Please log in first"
      redirect_to :action => "login"
      return false
    end
  end

  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(symbol)
    request.post? and params[symbol]
  end

  # Redirect to the previously requested URL (if present).
  def redirect_to_forwarding_url    
    if (redirect_url = session[:protected_page])
      session[:protected_page] = nil
      redirect_to redirect_url
    else
      redirect_to :action => "index"
    end
  end

  # Return a string with the status of the remember me checkbox.
  def remember_me_string
    cookies[:remember_me] || "0"
  end

  # Try to update the user, redirecting if successful.
  def try_to_update(user, attribute)
    if user.update_attributes(params[:user])
      flash[:notice] = "User #{attribute} updated."
      redirect_to :action => "index"
    end
  end

end
