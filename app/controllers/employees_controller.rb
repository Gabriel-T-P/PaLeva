class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @employees = Employee.employee
  end

  def new
    @employee = Employee.new
  end
  
  def create
    @employee = Employee.new(params.require(:employee).permit(:cpf, :email))
    @employee.establishment = current_user.establishment

    if @employee.save
      flash[:notice] = t '.notice'
      redirect_to root_path
    else
      flash.now[:alert] = t '.alert'
      render 'new'
    end
  end

end