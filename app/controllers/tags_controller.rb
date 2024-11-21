class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @tags = Tag.all
  end

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

  def edit
    @tag = Tag.find(params[:id])
  end
  
  
  private


  def tag_params
    params.require(:tag).permit(:name, :description)
  end

end