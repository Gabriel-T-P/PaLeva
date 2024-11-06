class MenusController < ApplicationController
  before_action :authenticate_user!

  def new
    @menu = Menu.new
    @dishs = Item.dish
    @beverages = Item.beverage
  end
  
end