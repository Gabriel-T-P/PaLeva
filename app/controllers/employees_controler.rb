class EmployeesController < ApplicationController

  def new
    @employee = Employee.new
  end
  

end