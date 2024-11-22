class PromotionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :extract_portions, only: [:new]
  before_action :set_promotion, only: [:show]

  def index
    @promotions = Promotion.all
  end

  def show
    @orders = @promotion.orders
  end

  def new
    @promotion = Promotion.new()
  end
  
  def create
    @promotion = Promotion.new(promotion_params)

    if @promotion.save
      flash[:notice] = t'.notice'
      redirect_to @promotion
    else
      flash.now[:alert] = t'.alert'
      extract_portions()
      render 'new'
    end
  end
  

  private

  def set_promotion
    begin
      @promotion = Promotion.find(params[:id])
    rescue
      return redirect_to root_path, alert: t('.promotion_not_found')
    end
  end

  def promotion_params
    params.require(:promotion).permit(:name, :start_date, :end_date, :percentage, :use_limit, portion_ids: [])
  end

  def extract_portions
    @portions_dish = current_user.establishment.items.dish.flat_map(&:portions)
    @portions_beverage = current_user.establishment.items.beverage.flat_map(&:portions)
  end

end