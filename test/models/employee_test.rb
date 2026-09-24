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

  test "passwort muss mindestens 12 Zeichen haben" do
    employee = Employee.new(name: "X", email: "x@restaurant.test",
                             password: "kurz1234", role: "server")
    assert_not employee.valid?
    assert_includes employee.errors[:password], "is too short (minimum is 12 characters)"
  end

  test "unbekannte Rolle ist ungültig" do
    employee = Employee.new(name: "X", email: "x@restaurant.test",
                             password: "irgendwas12345", role: "ceo")
    assert_not employee.valid?
  end

  test "manager kann sich mit korrektem Passwort authentifizieren" do
    assert employees(:manager).authenticate("geheim123456")
  end

  test "authenticate schlägt bei falschem Passwort fehl" do
    assert_not employees(:manager).authenticate("falschesPasswort123")
  end

  test "nur manager? liefert true für die manager-Fixture" do
    assert employees(:manager).manager?
    assert_not employees(:server).manager?
    assert_not employees(:kitchen).manager?
    assert_not employees(:bar).manager?
  end
end