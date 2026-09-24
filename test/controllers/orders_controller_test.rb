require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  def login_as(employee)
    post session_path, params: { email: employee.email, password: "geheim123456" }
  end

  test "Bestellung wird erfolgreich abgeschickt, wenn Artikel verfügbar sind" do
    post add_to_cart_path(menu_items(:pizza).id)

    assert_difference("Order.count", 1) do
      post checkout_path, params: {
        customer_name: "Test-Kunde", order_type: "pickup"
      }
    end

    follow_redirect!
    assert_response :success
  end

  test "Bestellung schlägt fehl und Warenkorb bleibt erhalten, wenn Artikel ausverkauft ist" do
    post add_to_cart_path(menu_items(:sold_out_pasta).id)

    assert_no_difference("Order.count") do
      post checkout_path, params: {
        customer_name: "Test-Kunde", order_type: "pickup"
      }
    end

    assert_redirected_to cart_path
  end

  test "kitchen darf Bestellung mit Küchen-Artikel vorantreiben" do
    login_as(employees(:kitchen))
    patch advance_order_path(orders(:pending_order))
    assert_redirected_to orders_path
    assert_equal "in_progress", orders(:pending_order).reload.status
  end

  test "bar darf Bestellung mit reinem Küchen-Artikel NICHT vorantreiben (fremder Datensatz/fremde Abteilung)" do
    login_as(employees(:bar))
    patch advance_order_path(orders(:pending_order))
    assert_redirected_to dashboard_path
    assert_equal "placed", orders(:pending_order).reload.status # unverändert
  end

  test "nicht eingeloggte Person kann keine Bestellung vorantreiben" do
    patch advance_order_path(orders(:pending_order))
    assert_redirected_to new_session_path
  end
end