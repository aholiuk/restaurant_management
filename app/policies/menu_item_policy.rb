class MenuItemPolicy < ApplicationPolicy
  def index?
    true # jeder darf das Menü sehen, auch Kunden (kein Login nötig)
  end

  def create?
    user&.manager?
  end

  def new?
    create?
  end

  def edit?
    create?
  end

  def update?
    create?
  end
end