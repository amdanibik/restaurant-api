require "rails_helper"

RSpec.describe "MenuItems API", type: :request do
  let(:restaurant) { Restaurant.find_by!(name: "Bangkok Street Kitchen") }

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
        }
      end.to change(MenuItem, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("Boat Noodles")
    end

    it "returns 422 with invalid params" do
      expect do
        post "/restaurants/#{restaurant.id}/menu_items", params: {
          menu_item: { name: "", price: nil }
        }
      end.not_to change(MenuItem, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end

    it "returns 404 for unknown restaurant" do
      post "/restaurants/999999/menu_items", params: {
        menu_item: { name: "Boat Noodles", price: 175 }
      }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to be_present
    end
  end

  describe "GET /restaurants/:restaurant_id/menu_items" do
    it "lists menu items for restaurant" do
      get "/restaurants/#{restaurant.id}/menu_items"

      names = JSON.parse(response.body).map { |item| item["name"] }

      expect(response).to have_http_status(:ok)
      expect(names).to include("Pad Thai", "Thai Iced Tea")
    end

    it "filters menu items by category" do
      get "/restaurants/#{restaurant.id}/menu_items", params: { category: "drink" }

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(body).not_to be_empty
      expect(body.map { |item| item["category"] }.uniq).to eq(["drink"])
      expect(body.map { |item| item["name"] }).to include("Thai Iced Tea")
    end

    it "returns 404 for unknown restaurant" do
      get "/restaurants/999999/menu_items"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to be_present
    end
  end

  describe "PUT /menu_items/:id" do
    let!(:menu_item) do
      restaurant.menu_items.find_by!(name: "Pad Thai")
    end

    it "updates menu item with valid params" do
      put "/menu_items/#{menu_item.id}", params: {
        menu_item: {
          price: 195,
          is_available: false
        }
      }

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
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end

    it "returns 404 for unknown id" do
      put "/menu_items/999999", params: {
        menu_item: { name: "Updated" }
      }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to be_present
    end
  end

  describe "DELETE /menu_items/:id" do
    it "deletes menu item" do
      menu_item = restaurant.menu_items.create!(name: "Delete Me", price: 90, category: "drink", is_available: true)

      expect do
        delete "/menu_items/#{menu_item.id}"
      end.to change(MenuItem, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 for unknown id" do
      delete "/menu_items/999999"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to be_present
    end
  end
end
