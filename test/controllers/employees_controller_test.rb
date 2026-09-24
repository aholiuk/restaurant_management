require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  def login_as(employee)
    post session_path, params: { email: employee.email, password: "geheim123456" }
  end

  test "server kann nicht die Mitarbeiterübersicht aufrufen" do
    login_as(employees(:server))
    get employees_path
    assert_redirected_to dashboard_path
  end

  test "server kann nicht die Daten eines anderen Mitarbeiters bearbeiten (fremder Datensatz)" do
    login_as(employees(:server))
    patch employee_path(employees(:kitchen)), params: { employee: { name: "Gehackt" } }

    assert_redirected_to dashboard_path
    assert_equal "Marco Koch", employees(:kitchen).reload.name # unverändert
  end

  test "manager kann die Daten eines Mitarbeiters bearbeiten" do
    login_as(employees(:manager))
    patch employee_path(employees(:server)), params: { employee: { role: "kitchen" } }

    assert_redirected_to employees_path
    assert_equal "kitchen", employees(:server).reload.role
  end

  test "manager kann sich nicht selbst löschen" do
    login_as(employees(:manager))
    assert_no_difference("Employee.count") do
      delete employee_path(employees(:manager))
    end
  end
end