class HomeController < ApplicationController

  def index
    if user_signed_in?
      @menus = current_user.establishment.menus
    end
  end

end