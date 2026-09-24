class RegistrationsController < ApplicationController
  before_action :require_login
  before_action :authorize_manager

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.role = params[:employee][:role].presence || "server"

    if @employee.save
      redirect_to employees_path, notice: "Mitarbeiter erstellt."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def authorize_manager
    authorize Employee, :create?
  end

  def employee_params
    params.require(:employee).permit(:name, :email, :password, :password_confirmation)
  end
end