class MenuItemsController < ApplicationController
  before_action :set_restaurant, only: [:create, :index]
  before_action :set_menu_item, only: [:update, :destroy]

  def create
    menu_item = @restaurant.menu_items.new(menu_item_params)

    if menu_item.save
      render json: menu_item, status: :created
    else
      render_validation_error(menu_item)
    end
  end

  def index
    menu_items = @restaurant.menu_items
    menu_items = menu_items.where(category: params[:category]) if params[:category].present?

    render json: menu_items
  end

  def update
    if @menu_item.update(menu_item_params)
      render json: @menu_item
    else
      render_validation_error(@menu_item)
    end
  end

  def destroy
    @menu_item.destroy
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price, :category, :is_available)
  end
end
