require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  def login_as(employee)
    post session_path, params: { email: employee.email, password: "geheim123456" }
  end

  test "manager darf die Registrierungsseite aufrufen" do
    login_as(employees(:manager))
    get new_registration_path
    assert_response :success
  end

  test "server wird von der Registrierungsseite abgewiesen" do
    login_as(employees(:server))
    get new_registration_path
    assert_redirected_to dashboard_path
    follow_redirect!
    assert_match "Dafür hast du keine Berechtigung.", @response.body
  end

  test "nicht eingeloggte Person wird zum Login umgeleitet" do
    get new_registration_path
    assert_redirected_to new_session_path
  end

  test "manager kann einen neuen Mitarbeiter anlegen" do
    login_as(employees(:manager))
    assert_difference("Employee.count", 1) do
      post registration_path, params: { employee: {
        name: "Neuer Mitarbeiter", email: "neu@restaurant.test",
        password: "geheim123456", password_confirmation: "geheim123456"
      } }
    end
    assert_equal "server", Employee.last.role # Rolle wird serverseitig erzwungen
  end
end