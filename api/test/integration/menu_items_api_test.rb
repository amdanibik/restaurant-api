require "test_helper"

class MenuItemsApiTest < ActionDispatch::IntegrationTest
  test "add menu item to restaurant" do
    restaurant = restaurants(:one)

    assert_difference("MenuItem.count", 1) do
      post "/restaurants/#{restaurant.id}/menu_items", params: {
        menu_item: {
          name: "Nasi Goreng",
          description: "Nasi goreng spesial",
          price: 25000,
          category: "main_course",
          is_available: true
        }
      }
    end

    assert_response :created
    body = JSON.parse(response.body)
    assert_equal "Nasi Goreng", body["name"]
  end

  test "list menu items for restaurant" do
    restaurant = restaurants(:one)

    get "/restaurants/#{restaurant.id}/menu_items"

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal restaurant.menu_items.count, body.length
  end

  test "list menu items with category filter" do
    restaurant = restaurants(:one)

    restaurant.menu_items.create!(
      name: "Es Teh",
      description: "Minuman dingin",
      price: 7000,
      category: "drink",
      is_available: true
    )

    restaurant.menu_items.create!(
      name: "Ayam Bakar",
      description: "Ayam bakar madu",
      price: 30000,
      category: "main_course",
      is_available: true
    )

    get "/restaurants/#{restaurant.id}/menu_items", params: { category: "drink" }

    assert_response :success
    body = JSON.parse(response.body)

    assert_equal 1, body.length
    assert_equal "drink", body.first["category"]
  end

  test "update menu item" do
    menu_item = menu_items(:one)

    put "/menu_items/#{menu_item.id}", params: {
      menu_item: {
        price: 12000,
        is_available: true
      }
    }

    assert_response :success

    menu_item.reload
    assert_equal BigDecimal("12000"), menu_item.price
    assert_equal true, menu_item.is_available
  end

  test "delete menu item" do
    menu_item = menu_items(:one)

    assert_difference("MenuItem.count", -1) do
      delete "/menu_items/#{menu_item.id}"
    end

    assert_response :no_content
  end
end
