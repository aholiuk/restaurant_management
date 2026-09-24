class OrdersController < ApplicationController
  before_action :require_login, only: [:index, :advance]
  before_action :set_order, only: [:advance]

  def index
    authorize Order
    @orders = if current_employee.manager?
                Order.where.not(status: "completed").order(:created_at)
              else
                Order.where.not(status: "completed")
                     .joins(:menu_items)
                     .where(menu_items: { department: current_employee.role })
                     .distinct
                     .order(:created_at)
              end
  end

  def advance
    authorize @order

    next_status = { "placed" => "in_progress", "in_progress" => "ready", "ready" => "completed" }[@order.status]
    @order.advance_status!(to: next_status, employee: current_employee)
    redirect_to orders_path, notice: "Status aktualisiert."
  rescue ArgumentError => e
    redirect_to orders_path, alert: e.message
  end
  def new
    @items = cart_items
    redirect_to cart_path, alert: "Dein Warenkorb ist leer." if @items.empty?
  end

  def create
    items = cart_items
    if items.empty?
      return redirect_to cart_path, alert: "Dein Warenkorb ist leer."
    end

    begin
      order = Order.place!(
        order_type: params[:order_type],
        customer_name: params[:customer_name],
        table_number: params[:table_number].presence,
        address: params[:address].presence,
        items: items.map { |e| { menu_item_id: e[:menu_item].id, quantity: e[:quantity] } }
      )

      session[:cart] = nil # Warenkorb leeren nach erfolgreicher Bestellung
      redirect_to order_confirmation_path(order)
    rescue MenuItem::SoldOutError => e
      redirect_to cart_path, alert: e.message
    rescue ActiveRecord::RecordInvalid => e
      redirect_to new_checkout_path, alert: e.message
    end
  end

  def confirmation
    @order = Order.find(params[:id])
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end