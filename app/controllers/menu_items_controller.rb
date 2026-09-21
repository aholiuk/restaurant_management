class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: [:edit, :update]

  def index
    @menu_items = MenuItem.all.order(:department, :name)
  end

  def new
    require_login
    authorize MenuItem
    @menu_item = MenuItem.new
  end

  def create
    require_login
    authorize MenuItem
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.save
      redirect_to menu_items_path, notice: "Menüartikel angelegt."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    require_login
    authorize @menu_item
  end

  def update
    require_login
    authorize @menu_item

    if @menu_item.update(menu_item_params)
      redirect_to menu_items_path, notice: "Menüartikel aktualisiert."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price, :department, :available)
  end
end