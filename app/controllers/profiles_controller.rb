class ProfilesController < ApplicationController
  before_action :require_login

  def show
    @employee = current_employee
  end

  def edit
    @employee = current_employee
  end

  def update
    @employee = current_employee

    if params[:employee][:password].present?
      unless @employee.authenticate(params[:employee][:current_password])
        @employee.errors.add(:current_password, "ist falsch")
        return render :edit, status: :unprocessable_entity
      end
    end

    if params[:employee][:new_email].present?
      token = @employee.request_email_change!(params[:employee][:new_email])
      Rails.logger.info "BESTÄTIGUNGSLINK für #{params[:employee][:new_email]}: #{confirm_email_url(token: token)}"
    end

    if @employee.update(profile_params)
      redirect_to profile_path, notice: "Profil aktualisiert. Falls du eine neue E-Mail angefordert hast, prüfe den Server-Log für den Bestätigungslink."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_email
    employee = Employee.find_by(confirmation_token: params[:token])

    if employee&.confirm_email_change!
      redirect_to profile_path, notice: "E-Mail-Adresse bestätigt und aktualisiert."
    else
      redirect_to profile_path, alert: "Ungültiger oder abgelaufener Bestätigungslink."
    end
  end

  private

  def profile_params
    params.require(:employee).permit(:name, :password, :password_confirmation)
  end
end