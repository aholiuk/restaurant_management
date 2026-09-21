class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :handle_unauthorized

  helper_method :current_employee, :logged_in?

  private

  def current_employee
    @current_employee ||= Employee.find_by(id: session[:employee_id])
  end

  def logged_in?
    current_employee.present?
  end

  def require_login
    return if logged_in?

    redirect_to new_session_path, alert: "Bitte melde dich an."
  end

  def pundit_user
    current_employee
  end

  def handle_unauthorized
    redirect_to dashboard_path, alert: "Dafür hast du keine Berechtigung."
  end
end