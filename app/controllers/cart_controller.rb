class CartController < ApplicationController
  def show
    @items = cart_items
  end

  def add
    session[:cart] ||= {}
    id = params[:menu_item_id]
    session[:cart][id] = (session[:cart][id] || 0) + 1
    redirect_back fallback_location: menu_items_path, notice: "Zum Warenkorb hinzugefügt."
  end

  def decrease
    id = params[:menu_item_id]
    if session[:cart]&.key?(id)
      session[:cart][id] -= 1
      session[:cart].delete(id) if session[:cart][id] <= 0
    end
    redirect_back fallback_location: cart_path
  end

  def remove
    session[:cart]&.delete(params[:menu_item_id])
    redirect_back fallback_location: cart_path, notice: "Entfernt."
  end
end