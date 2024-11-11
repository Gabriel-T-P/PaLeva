class EmployeesController < ApplicationController

  def new
    @employee = Employee.new
  end
  
  def create
    @employee = Employee.new(params.require(:employee).permit(:cpf, :email))

    if @employee.save
      flash[:notice] = t '.notice'
      redirect_to root_path
    else
      flash.now[:alert] = t '.alert'
      render 'new'
    end
  end
  

end