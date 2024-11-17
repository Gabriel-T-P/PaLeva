class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :internal_error_500
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error_404


  private

  def internal_error_500
    return render status: 500, json: {result: I18n.t('.api_order_internal_error')}
  end
  
  def not_found_error_404
    return render status: 404, json: {result: I18n.t('.api_order_not_found')}
  end
  
end