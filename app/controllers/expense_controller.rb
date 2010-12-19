class ExpenseController < ApplicationController
  include ApplicationHelper  
  skip_before_filter :verify_authenticity_token
  #before_filter :protect, :only => [:index, :edit]

  def index
    unless session[:user_id]
      flash[:notice] = "Please log in first"
      redirect_to :action => "login"
      return
    end
    @title = "Your Expenditures"
    @user = User.find(session[:user_id])
    @expenditures = Expense.find_all_by_user_id(@user.id)
    # This will be a protected page for viewing user information.
  end

  def new
    unless session[:user_id]
      flash[:notice] = "Please log in first"
      redirect_to :action => "login"
      return
    end
    @title = "Create New Expenditure"
    @user = User.find(session[:user_id])
    if param_posted?(:expense)
      @expense = Expense.new(params[:expense])
      @expense.user_id = @user.id
      if @expense.save
          flash[:notice] = "Expenditure #{@expense.name} created successfully!"
          redirect_to :action => "index"        
      else
        flash[:notice] = "Problem Creating Item #{@expense.name}"
      end    
    end
  end

  def search
      unless session[:user_id]
        flash[:notice] = "Please log in first"
        redirect_to :action => "login"
        return
      end      
      @title = "Your Expenditures"
      @user = User.find(session[:user_id])      
      @start_date = params[:expense_from_date].present? ? params[:expense_from_date] : 100.years.ago.to_date
      @end_date = params[:expense_to_date].present? ? params[:expense_to_date] : 100.years.from_now.to_date
      @expenditures = Expense.find_all_by_user_id(@user.id, :conditions => ["expense_date >= (?) AND expense_date <= (?) ", @start_date.to_date.strftime("%Y-%m-%d"), @end_date.to_date.strftime("%Y-%m-%d")])
  end

  def delete
      @title = "Delete Expenditure"
      @user = User.find(session[:user_id])
      @expense = Expense.find(params[:id])
      allow! :exec => :check_user
      @expense.destroy
      flash[:notice] = "Expenditure reverted successfully!"
      redirect_to :action => "index"
  end

  private

  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(symbol)
    request.post? and params[symbol]
  end

  def check_user
    @user.id == @expense.user_id
  end
end
