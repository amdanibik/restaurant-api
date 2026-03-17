require "test_helper"

class RestaurantsApiTest < ActionDispatch::IntegrationTest
  test "create restaurant" do
    assert_difference("Restaurant.count", 1) do
      post "/restaurants", params: {
        restaurant: {
          name: "Warung Sederhana",
          address: "Jl. Merdeka 10",
          phone: "08123456789",
          opening_hours: "08:00-21:00"
        }
      }
    end

    assert_response :created
    body = JSON.parse(response.body)
    assert_equal "Warung Sederhana", body["name"]
  end

  test "list restaurants" do
    get "/restaurants"

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal Restaurant.count, body.length
  end

  test "show restaurant detail including menu items" do
    restaurant = restaurants(:one)

    get "/restaurants/#{restaurant.id}"

    assert_response :success
    body = JSON.parse(response.body)

    assert_equal restaurant.id, body["id"]
    assert body.key?("menu_items")
  end

  test "update restaurant" do
    restaurant = restaurants(:one)

    put "/restaurants/#{restaurant.id}", params: {
      restaurant: {
        name: "Nama Baru"
      }
    }

    assert_response :success
    assert_equal "Nama Baru", restaurant.reload.name
  end

  test "delete restaurant" do
    restaurant = restaurants(:one)

    assert_difference("Restaurant.count", -1) do
      delete "/restaurants/#{restaurant.id}"
    end

    assert_response :no_content
  end
end
