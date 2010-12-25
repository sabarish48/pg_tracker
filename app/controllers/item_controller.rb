class ItemController < ApplicationController
  include ApplicationHelper
  include ItemHelper
  skip_before_filter :verify_authenticity_token
  #before_filter :protect, :only => [:index, :edit]

  def index
    unless session[:user_id]
      flash[:notice] = "Please log in first"
      redirect_to :action => "login"
      return
    end
    @title = "Your Transactions"
    @user = User.find(session[:user_id])
    user_items = UserItem.find_all_by_user_id(@user.id).collect(&:item_id)
    @items = Item.find(:all, :conditions => ["id IN (?)", user_items])    
    current_page = (params[:page] || 1).to_i

    sort = case params[:sort]
    when "name"  then "name"
    when "user_id"   then "user_id"
    when "amount" then "amount"
    when "date" then "transaction_date"
    when "name_reverse"  then "name DESC"
    when "user_id_reverse"  then "user_id DESC"
    when "amount_reverse"   then "amount DESC"
    when "date_reverse" then "transaction_date DESC"
    end
    @all_items = Item.paginate(:all, :conditions => ["(id IN (?) OR user_id = ?) AND name like ?", user_items, @user.id, "%#{params[:search]}%"], :order => sort || "transaction_date DESC", :page => current_page, :per_page => 10)
  end

  def new
    unless session[:user_id]
      flash[:notice] = "Please log in first"
      redirect_to :action => "login"
      return
    end
    @title = "Create New Item"
    @user = User.find(session[:user_id])
    if param_posted?(:item) && param_posted?(:record)
      @item = Item.new(params[:item])
      @item.user_id = @user.id      
      if @item.save
        if param_posted?(:record)
          user_items = params[:record][:users]
          user_items.each do |user_item|
            @user_item = UserItem.new(:user_id => user_item, :item_id => @item.id)
            #@user_item.amount = @user.id.to_s == user_item ? -1*(@item.amount/user_items.count) :@item.amount/user_items.count
            @user_item.amount = @item.amount/user_items.count
            @user_item.save
          end        
          flash[:notice] = "Item #{@item.name} created successfully!"
          redirect_to :action => "index"
        end
      else
        flash[:notice] = "Problem Creating Item #{@item.name}"
      end
    elsif param_posted?(:item)
        flash[:notice] = "Select atleast one User"
    end
  end

  def show
      unless session[:user_id]
        flash[:notice] = "Please log in first"
        redirect_to :action => "login"
        return
      end
      @title = "Show Item"
      @user = User.find(session[:user_id])
      @item = Item.find(params[:id])          
  end

  def delete      
      @title = "Delete Item"
      @user = User.find(session[:user_id])
      @item = Item.find(params[:id])
      allow! :exec => :check_user
      UserItem.find_all_by_item_id(@item.id).each do |user_item|
          user_item.destroy
      end
      @item.destroy
      flash[:notice] = "Item reverted successfully!"
      redirect_to :action => "index"
  end

  private  

  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(symbol)
    request.post? and params[symbol]
  end

  def check_user
    @user.id == @item.user_id
  end
end
