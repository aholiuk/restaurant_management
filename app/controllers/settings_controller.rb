class SettingsController < ApplicationController
  before_action :require_login

  def edit
    @setting = Setting.current
    authorize @setting
  end

  def update
    @setting = Setting.current
    authorize @setting
    @setting.update!(theme: params[:setting][:theme], restaurant_name: params[:setting][:restaurant_name])
    redirect_to edit_setting_path, notice: "Design aktualisiert."
  end
end