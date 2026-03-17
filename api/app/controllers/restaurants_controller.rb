class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :destroy]

  def create
    restaurant = Restaurant.new(restaurant_params)

    if restaurant.save
      render json: restaurant, status: :created
    else
      render_validation_error(restaurant)
    end
  end

  def index
    render json: Restaurant.all
  end

  def show
    render json: @restaurant.as_json(include: :menu_items)
  end

  def update
    if @restaurant.update(restaurant_params)
      render json: @restaurant
    else
      render_validation_error(@restaurant)
    end
  end

  def destroy
    @restaurant.destroy
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone, :opening_hours)
  end
end
