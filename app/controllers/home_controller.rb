class HomeController < ApplicationController

  def index
    if user_signed_in?
      @menus = current_user.establishment.menus
      @order = current_order
    end
  end

end