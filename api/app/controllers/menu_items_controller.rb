class MenuItemsController < ApplicationController
  # Untuk create/index, menu item selalu dalam konteks restoran tertentu.
  before_action :set_restaurant, only: [:create, :index]
  # Untuk update/destroy, lookup langsung berdasarkan id menu item.
  before_action :set_menu_item, only: [:update, :destroy]

  # Menambah menu item baru ke restoran.
  def create
    menu_item = @restaurant.menu_items.new(menu_item_params)

    if menu_item.save
      render json: menu_item, status: :created
    else
      render_validation_error(menu_item)
    end
  end

  # List menu item dengan dukungan filter category/name dan pagination.
  def index
    menu_items = @restaurant.menu_items.order(:id)
    menu_items = menu_items.where(category: params[:category]) if params[:category].present?
    menu_items = menu_items.where("name LIKE ?", "%#{MenuItem.sanitize_sql_like(params[:name])}%") if params[:name].present?

    render json: paginated_payload(menu_items)
  end

  # Update data menu item berdasarkan id.
  def update
    if @menu_item.update(menu_item_params)
      render json: @menu_item
    else
      render_validation_error(@menu_item)
    end
  end

  # Hapus menu item berdasarkan id.
  def destroy
    @menu_item.destroy
    head :no_content
  end

  private

  # Lookup restoran dari path parameter :restaurant_id.
  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  # Lookup menu item dari path parameter :id.
  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  # Strong params untuk payload menu item.
  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price, :category, :is_available)
  end
end
