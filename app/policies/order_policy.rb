class OrderPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def update?
    return false unless user

    user.manager? || record.menu_items.pluck(:department).include?(user.role)
  end

  def advance?
    update?
  end
end