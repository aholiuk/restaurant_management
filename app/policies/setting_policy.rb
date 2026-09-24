class SettingPolicy < ApplicationPolicy
  def edit?
    user&.manager?
  end

  def update?
    edit?
  end
end