class EmployeesController < ApplicationController
  before_action :require_login
  before_action :set_employee, only: [:edit, :update, :destroy]

  def index
    authorize Employee
    @employees = Employee.order(:name)
  end

  def edit
    authorize @employee
  end

  def update
    authorize @employee

    if @employee.update(employee_params)
      redirect_to employees_path, notice: "Mitarbeiter aktualisiert."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @employee
    @employee.destroy
    redirect_to employees_path, notice: "Mitarbeiter gelöscht."
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:name, :role, :active)
  end
end