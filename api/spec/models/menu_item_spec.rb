require "rails_helper"

RSpec.describe MenuItem, type: :model do
  let(:restaurant) do
    Restaurant.create!(name: "Phuket Test Grill", address: "Patong Test Road")
  end

  describe "validations" do
    it "is valid with required attributes" do
      menu_item = described_class.new(
        restaurant: restaurant,
        name: "Thai Iced Tea",
        price: 60,
        category: "drink"
      )

      expect(menu_item).to be_valid
    end

    it "is invalid without name" do
      menu_item = described_class.new(restaurant: restaurant, price: 60)

      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:name]).to include("can't be blank")
    end

    it "is invalid without price" do
      menu_item = described_class.new(restaurant: restaurant, name: "Fresh Lime Soda")

      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:price]).to include("can't be blank")
    end

    it "is invalid without restaurant" do
      menu_item = described_class.new(name: "Fresh Lime Soda", price: 70)

      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:restaurant]).to include("must exist")
    end
  end
end
