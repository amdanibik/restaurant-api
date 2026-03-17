require "rails_helper"

RSpec.describe "Restaurants API", type: :request do
  describe "POST /restaurants" do
    it "creates a restaurant with valid params" do
      expect do
        post "/restaurants", params: {
          restaurant: {
            name: "Ayutthaya Noodle House",
            address: "Old City Road, Ayutthaya",
            phone: "+66 845551234",
            opening_hours: "10:00 - 21:00"
          }
        }
      end.to change(Restaurant, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("Ayutthaya Noodle House")
    end

    it "returns 422 with invalid params" do
      expect do
        post "/restaurants", params: { restaurant: { name: "", address: "" } }
      end.not_to change(Restaurant, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "GET /restaurants" do
    it "returns list of restaurants" do
      get "/restaurants"

      names = JSON.parse(response.body).map { |item| item["name"] }

      expect(response).to have_http_status(:ok)
      expect(names).to include("Bangkok Street Kitchen", "Chiang Mai Spice House", "Phuket Seafood Grill")
    end
  end

  describe "GET /restaurants/:id" do
    it "returns restaurant detail including menu items" do
      restaurant = Restaurant.find_by!(name: "Bangkok Street Kitchen")

      get "/restaurants/#{restaurant.id}"

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(body["id"]).to eq(restaurant.id)
      expect(body["menu_items"]).to be_an(Array)
      expect(body["menu_items"].size).to be >= 5
      expect(body["menu_items"].map { |item| item["name"] }).to include("Pad Thai")
    end

    it "returns 404 for unknown id" do
      get "/restaurants/999999"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to be_present
    end
  end

  describe "PUT /restaurants/:id" do
    let!(:restaurant) { Restaurant.create!(name: "Resto Lama", address: "Jl. Lama") }

    it "updates restaurant with valid params" do
      put "/restaurants/#{restaurant.id}", params: { restaurant: { name: "Resto Baru" } }

      expect(response).to have_http_status(:ok)
      expect(restaurant.reload.name).to eq("Resto Baru")
    end

    it "returns 422 with invalid params" do
      put "/restaurants/#{restaurant.id}", params: { restaurant: { name: "", address: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to be_present
    end
  end

  describe "DELETE /restaurants/:id" do
    it "deletes restaurant" do
      restaurant = Restaurant.create!(name: "Resto Hapus", address: "Jl. Hapus")

      expect do
        delete "/restaurants/#{restaurant.id}"
      end.to change(Restaurant, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 for unknown id" do
      delete "/restaurants/999999"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to be_present
    end
  end
end
