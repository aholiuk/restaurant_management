require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "place! erstellt eine Bestellung, wenn der Artikel verfügbar ist" do
    order = Order.place!(
      order_type: "pickup",
      customer_name: "Test-Kunde",
      items: [{ menu_item_id: menu_items(:pizza).id, quantity: 1 }]
    )

    assert order.persisted?
    assert_equal "placed", order.status
    assert_equal menu_items(:pizza).price, order.order_items.first.price_at_order
  end

  test "place! lehnt einen ausverkauften Artikel ab" do
    assert_raises(MenuItem::SoldOutError) do
      Order.place!(
        order_type: "pickup",
        customer_name: "Test-Kunde",
        items: [{ menu_item_id: menu_items(:sold_out_pasta).id, quantity: 1 }]
      )
    end

    assert_equal 0, Order.where(customer_name: "Test-Kunde").count
  end

  test "place! lässt bei zwei Anfragen für den letzten Artikel nur eine zu" do
    Order.place!(order_type: "pickup", customer_name: "Erste Anfrage",
                 items: [{ menu_item_id: menu_items(:pizza).id, quantity: 1 }])
    menu_items(:pizza).update!(available: false)

    assert_raises(MenuItem::SoldOutError) do
      Order.place!(order_type: "pickup", customer_name: "Zweite Anfrage",
                   items: [{ menu_item_id: menu_items(:pizza).id, quantity: 1 }])
    end
  end

  test "advance_status! erlaubt einen gültigen Übergang und protokolliert ihn" do
    order = orders(:pending_order)
    order.advance_status!(to: "in_progress", employee: employees(:manager))

    assert_equal "in_progress", order.status
    log = order.status_logs.order(:changed_at).last
    assert_equal "in_progress", log.status
    assert_equal employees(:manager), log.employee
  end

  test "advance_status! lehnt einen ungültigen Übergang ab" do
    order = orders(:pending_order) # Status: placed
    assert_raises(ArgumentError) do
      order.advance_status!(to: "completed", employee: employees(:manager))
    end
  end

  test "dine_in ohne Tischnummer ist ungültig" do
    order = Order.new(order_type: "dine_in", customer_name: "Max", status: "placed")
    assert_not order.valid?
    assert_includes order.errors[:table_number], "can't be blank"
  end

  test "delivery ohne Adresse ist ungültig" do
    order = Order.new(order_type: "delivery", customer_name: "Max", status: "placed")
    assert_not order.valid?
    assert_includes order.errors[:address], "can't be blank"
  end
end