class SiteController < ApplicationController
  def index
    @title = "Welcome to PG Tracker!"
  end
  def about
    @title = "About Tracker"
  end
  def help
    @title = "Tracker Help"
  end
end
