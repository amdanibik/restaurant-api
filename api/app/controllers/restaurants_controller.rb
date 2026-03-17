class RestaurantsController < ApplicationController
  # Reuse lookup restoran untuk aksi berbasis id.
  before_action :set_restaurant, only: [:show, :update, :destroy]

  # Membuat restoran baru.
  def create
    restaurant = Restaurant.new(restaurant_params)

    if restaurant.save
      render json: restaurant, status: :created
    else
      render_validation_error(restaurant)
    end
  end

  # Menampilkan daftar restoran dengan pagination.
  def index
    render json: paginated_payload(Restaurant.order(:id))
  end

  # Detail restoran beserta menu item yang dimiliki.
  def show
    render json: @restaurant.as_json(include: :menu_items)
  end

  # Update data restoran berdasarkan id.
  def update
    if @restaurant.update(restaurant_params)
      render json: @restaurant
    else
      render_validation_error(@restaurant)
    end
  end

  # Hapus restoran (menu item ikut terhapus via dependent: :destroy).
  def destroy
    @restaurant.destroy
    head :no_content
  end

  private

  # Lookup restoran dari path parameter :id.
  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  # Strong params untuk mencegah mass-assignment field yang tidak diizinkan.
  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone, :opening_hours)
  end
end
