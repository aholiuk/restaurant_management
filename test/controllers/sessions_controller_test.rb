require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "erfolgreicher Login mit korrekten Zugangsdaten" do
    post session_path, params: { email: "anna@restaurant.test", password: "geheim123456" }
    assert_redirected_to dashboard_path
  end

  test "Login schlägt mit falschem Passwort fehl" do
    post session_path, params: { email: "anna@restaurant.test", password: "falschesPasswort" }
    assert_response :unprocessable_entity
  end

  test "Login schlägt mit unbekannter E-Mail fehl" do
    post session_path, params: { email: "niemand@restaurant.test", password: "geheim123456" }
    assert_response :unprocessable_entity
  end

  test "geschützte Seite ohne Login leitet zum Login um" do
    get dashboard_path
    assert_redirected_to new_session_path
  end

  test "geschützte Seite ist nach Login erreichbar" do
    post session_path, params: { email: "anna@restaurant.test", password: "geheim123456" }
    get dashboard_path
    assert_response :success
  end
end