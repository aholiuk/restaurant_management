class ActivityController < ApplicationController
  before_action :require_login

  def index
    @logs = StatusLog.includes(:order, :employee).order(changed_at: :desc).limit(50)
  end
end