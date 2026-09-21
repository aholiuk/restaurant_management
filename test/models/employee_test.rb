require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test "fixtures sind gültig" do
    assert employees(:manager).valid?
    assert employees(:server).valid?
  end

  test "email muss eindeutig sein" do
    duplicate = Employee.new(name: "Zweite Anna", email: "anna@restaurant.test",
                              password: "irgendwas12345", role: "server")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "unbekannte Rolle ist ungültig" do
    employee = Employee.new(name: "X", email: "x@restaurant.test",
                             password: "irgendwas12345", role: "ceo")
    assert_not employee.valid?
  end

  test "manager kann sich mit korrektem Passwort authentifizieren" do
    assert employees(:manager).authenticate("geheim123456")
  end
end