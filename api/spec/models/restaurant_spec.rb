require "rails_helper"

RSpec.describe Restaurant, type: :model do
  describe "validations" do
    it "is valid with required attributes" do
      restaurant = described_class.new(name: "Bangkok Test Kitchen", address: "Sukhumvit Test Road")

      expect(restaurant).to be_valid
    end

    it "is invalid without name" do
      restaurant = described_class.new(address: "Sukhumvit Test Road")

      expect(restaurant).not_to be_valid
      expect(restaurant.errors[:name]).to include("can't be blank")
    end

    it "is invalid without address" do
      restaurant = described_class.new(name: "Bangkok Test Kitchen")

      expect(restaurant).not_to be_valid
      expect(restaurant.errors[:address]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "destroys associated menu items when destroyed" do
      restaurant = described_class.create!(name: "Chiang Mai Test House", address: "Nimmanhaemin Test Road")
      restaurant.menu_items.create!(name: "Khao Soi", price: 190, category: "main", is_available: true)

      expect { restaurant.destroy }.to change(MenuItem, :count).by(-1)
    end
  end
end
