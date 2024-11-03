class TagsController < ApplicationController
  before_action :authenticate_user!

  def new
    @tag = Tag.new
  end
  
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:notice] = t '.notice'
      redirect_to root_path
    else
      flash.now[:alert] = t '.alert'
      render 'new'
    end
  end
  
  private

  def tag_params
    params.require(:tag).permit(:name, :description)
  end

end