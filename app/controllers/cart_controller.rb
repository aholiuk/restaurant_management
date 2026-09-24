class CartController < ApplicationController
  def show
    @items = cart_items
  end

  def add
    session[:cart] ||= {}
    id = params[:menu_item_id]
    session[:cart][id] = (session[:cart][id] || 0) + 1
    redirect_to cart_path, notice: "Zum Warenkorb hinzugefügt."
  end

  def remove
    session[:cart]&.delete(params[:menu_item_id])
    redirect_to cart_path, notice: "Entfernt."
  end
end