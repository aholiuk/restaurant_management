class EmployeePolicy < ApplicationPolicy
  # "user" ist hier der current_employee (siehe pundit_user), "record" das
  # Employee-Objekt, um das es geht (z.B. der neu anzulegende Mitarbeiter).

  def create?
    user&.manager?
  end

  def new?
    create?
  end

  def index?
    user&.manager?
  end

  def update?
    user&.manager?
  end
end