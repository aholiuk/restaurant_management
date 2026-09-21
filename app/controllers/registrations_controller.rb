class RegistrationsController < ApplicationController
  before_action :require_login
  before_action :authorize_manager

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    # Selbstregistrierung ergibt immer die niedrigste Berechtigungsstufe;
    # der Chef weist später über die Benutzerverwaltung ggf. eine andere Rolle zu.
    @employee.role = "server"

    if @employee.save
      redirect_to root_path, notice: "Konto erstellt. Login folgt im nächsten Schritt."
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