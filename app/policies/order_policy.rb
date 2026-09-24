class OrderPolicy < ApplicationPolicy
  def index?
    user.present? # jeder eingeloggte Mitarbeiter darf Bestellungen sehen
  end

  def update?
    return false unless user

    # Chef darf immer; Küche/Bar nur Bestellungen mit Artikeln der eigenen Abteilung
    user.manager? || record.menu_items.pluck(:department).include?(user.role)
  end
end