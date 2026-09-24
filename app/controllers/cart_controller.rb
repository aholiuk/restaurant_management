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

  private

  # Baut aus der Session (nur IDs + Mengen) die tatsächlichen MenuItem-Objekte
  # samt aktuellem Preis und Verfügbarkeit für die Anzeige.
  def cart_items
    return [] if session[:cart].blank?

    session[:cart].filter_map do |menu_item_id, quantity|
      menu_item = MenuItem.find_by(id: menu_item_id)
      next unless menu_item

      { menu_item: menu_item, quantity: quantity }
    end
  end
  helper_method :cart_items
end