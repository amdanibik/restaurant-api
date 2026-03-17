require "rails_helper"

RSpec.describe "MenuItems API", type: :request do
  let(:headers) { { "X-API-Key" => ENV.fetch("API_KEY", "development-api-key") } }

  def parsed_body
    JSON.parse(response.body)
  end

  let(:restaurant) do
    Restaurant.create!(
      name: "Bangkok Street Kitchen",
      address: "Sukhumvit Road, Bangkok",
      phone: "+66 812345678",
      opening_hours: "10:00 - 22:00"
    )
  end

  describe "POST /restaurants/:restaurant_id/menu_items" do
    it "creates menu item with valid params" do
      expect do
        post "/restaurants/#{restaurant.id}/menu_items", params: {
          menu_item: {
            name: "Boat Noodles",
            description: "Rice noodles in aromatic Thai broth with beef slices",
            price: 175,
            category: "main",
            is_available: true
          }
        }, headers: headers
      end.to change(MenuItem, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(parsed_body["name"]).to eq("Boat Noodles")
    end

    it "returns 422 with invalid params" do
      expect do
        post "/restaurants/#{restaurant.id}/menu_items", params: {
          menu_item: { name: "", price: nil }
        }, headers: headers
      end.not_to change(MenuItem, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_body["error"]).to eq("Validation failed")
      expect(parsed_body["errors"]).to be_present
    end

    it "returns 400 when menu item payload is missing" do
      post "/restaurants/#{restaurant.id}/menu_items", params: { name: "Boat Noodles" }, headers: headers

      expect(response).to have_http_status(:bad_request)
      expect(parsed_body["error"]).to eq("Bad request")
    end

    it "returns 404 for unknown restaurant" do
      post "/restaurants/999999/menu_items", params: {
        menu_item: { name: "Boat Noodles", price: 175 }
      }, headers: headers

      expect(response).to have_http_status(:not_found)
      expect(parsed_body["error"]).to eq("Resource not found")
    end
  end

  describe "GET /restaurants/:restaurant_id/menu_items" do
    before do
      restaurant.menu_items.create!(name: "Spring Rolls", price: 120, category: "appetizer", is_available: true)
      restaurant.menu_items.create!(name: "Chicken Satay", price: 150, category: "appetizer", is_available: true)
      restaurant.menu_items.create!(name: "Pad Thai", price: 180, category: "main", is_available: true)
      restaurant.menu_items.create!(name: "Thai Fried Rice", price: 160, category: "main", is_available: true)
      restaurant.menu_items.create!(name: "Mango Sticky Rice", price: 140, category: "dessert", is_available: true)
      restaurant.menu_items.create!(name: "Thai Iced Tea", price: 60, category: "drink", is_available: true)
      restaurant.menu_items.create!(name: "Coconut Water", price: 70, category: "drink", is_available: true)
      restaurant.menu_items.create!(name: "Green Curry Chicken", price: 200, category: "main", is_available: true)
    end

    it "lists menu items for restaurant" do
      get "/restaurants/#{restaurant.id}/menu_items", headers: headers

      body = parsed_body
      names = body["data"].map { |item| item["name"] }

      expect(response).to have_http_status(:ok)
      expect(names).to include("Pad Thai", "Thai Iced Tea")
      expect(body["pagination"]["current_page"]).to eq(1)
    end

    it "filters menu items by category" do
      get "/restaurants/#{restaurant.id}/menu_items", params: { category: "drink" }, headers: headers

      body = parsed_body["data"]
      expect(response).to have_http_status(:ok)
      expect(body).not_to be_empty
      expect(body.map { |item| item["category"] }.uniq).to eq(["drink"])
      expect(body.map { |item| item["name"] }).to include("Thai Iced Tea")
    end

    it "filters menu items by name" do
      get "/restaurants/#{restaurant.id}/menu_items", params: { name: "tea" }, headers: headers

      body = parsed_body["data"]
      expect(response).to have_http_status(:ok)
      expect(body.map { |item| item["name"] }).to include("Thai Iced Tea")
      expect(body.map { |item| item["name"] }).not_to include("Pad Thai")
    end

    it "supports pagination parameters" do
      get "/restaurants/#{restaurant.id}/menu_items", params: { page: 2, per_page: 3 }, headers: headers

      body = parsed_body
      expect(response).to have_http_status(:ok)
      expect(body["data"].size).to eq(3)
      expect(body["pagination"]).to include(
        "current_page" => 2,
        "per_page" => 3,
        "total_count" => 8
      )
    end

    it "returns 404 for unknown restaurant" do
      get "/restaurants/999999/menu_items", headers: headers

      expect(response).to have_http_status(:not_found)
      expect(parsed_body["error"]).to eq("Resource not found")
    end
  end

  describe "PUT /menu_items/:id" do
    let!(:menu_item) do
      restaurant.menu_items.create!(name: "Pad Thai", price: 180, category: "main", is_available: true)
    end

    it "updates menu item with valid params" do
      put "/menu_items/#{menu_item.id}", params: {
        menu_item: {
          price: 195,
          is_available: false
        }
      }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(menu_item.reload.price).to eq(BigDecimal("195"))
      expect(menu_item.is_available).to be(false)
    end

    it "returns 422 with invalid params" do
      put "/menu_items/#{menu_item.id}", params: {
        menu_item: {
          name: "",
          price: nil
        }
      }, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(parsed_body["error"]).to eq("Validation failed")
      expect(parsed_body["errors"]).to be_present
    end

    it "returns 404 for unknown id" do
      put "/menu_items/999999", params: {
        menu_item: { name: "Updated" }
      }, headers: headers

      expect(response).to have_http_status(:not_found)
      expect(parsed_body["error"]).to eq("Resource not found")
    end
  end

  describe "DELETE /menu_items/:id" do
    it "deletes menu item" do
      menu_item = restaurant.menu_items.create!(name: "Delete Me", price: 90, category: "drink", is_available: true)

      expect do
        delete "/menu_items/#{menu_item.id}", headers: headers
      end.to change(MenuItem, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 for unknown id" do
      delete "/menu_items/999999", headers: headers

      expect(response).to have_http_status(:not_found)
      expect(parsed_body["error"]).to eq("Resource not found")
    end
  end
end
