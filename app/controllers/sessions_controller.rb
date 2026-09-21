class SessionsController < ApplicationController
  def new
  end

  def create
    employee = Employee.authenticate_by(email: params[:email], password: params[:password])

    if employee
      session[:employee_id] = employee.id
      redirect_to dashboard_path, notice: "Angemeldet."
    else
      flash.now[:alert] = "E-Mail oder Passwort ist falsch."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:employee_id] = nil
    redirect_to new_session_path, notice: "Abgemeldet."
  end
end