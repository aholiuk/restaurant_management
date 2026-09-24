require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  def login_as(employee)
    post session_path, params: { email: employee.email, password: "geheim123456" }
  end

  test "eingeloggter Mitarbeiter sieht sein eigenes Profil" do
    login_as(employees(:server))
    get profile_path
    assert_response :success
    assert_match "Lisa Kellner", @response.body
  end

  test "nicht eingeloggte Person wird vom Profil zum Login umgeleitet" do
    get profile_path
    assert_redirected_to new_session_path
  end

  test "Name kann ohne Passwortänderung aktualisiert werden" do
    login_as(employees(:server))
    patch profile_path, params: { employee: { name: "Lisa Neu" } }

    assert_redirected_to profile_path
    assert_equal "Lisa Neu", employees(:server).reload.name
  end

  test "Passwortänderung schlägt mit falschem aktuellem Passwort fehl" do
    login_as(employees(:server))
    patch profile_path, params: {
      employee: {
        name: "Lisa Kellner",
        current_password: "falschesPasswort",
        password: "neuesPasswort12345",
        password_confirmation: "neuesPasswort12345"
      }
    }

    assert_response :unprocessable_entity
    assert employees(:server).reload.authenticate("geheim123456") # altes Passwort gilt weiterhin
  end

  test "Passwortänderung gelingt mit korrektem aktuellem Passwort" do
    login_as(employees(:server))
    patch profile_path, params: {
      employee: {
        name: "Lisa Kellner",
        current_password: "geheim123456",
        password: "neuesPasswort12345",
        password_confirmation: "neuesPasswort12345"
      }
    }

    assert_redirected_to profile_path
    assert employees(:server).reload.authenticate("neuesPasswort12345")
  end

  test "E-Mail-Änderung erstellt einen Bestätigungstoken, ändert die E-Mail aber noch nicht" do
    login_as(employees(:server))
    patch profile_path, params: { employee: { name: "Lisa Kellner", new_email: "neue@restaurant.test" } }

    employee = employees(:server).reload
    assert_equal "lisa@restaurant.test", employee.email # noch unverändert
    assert_equal "neue@restaurant.test", employee.unconfirmed_email
    assert_not_nil employee.confirmation_token
  end

  test "Bestätigungslink aktualisiert die E-Mail wirklich" do
    login_as(employees(:server))
    patch profile_path, params: { employee: { name: "Lisa Kellner", new_email: "neue@restaurant.test" } }
    token = employees(:server).reload.confirmation_token

    get confirm_email_path(token: token)

    assert_equal "neue@restaurant.test", employees(:server).reload.email
  end
end