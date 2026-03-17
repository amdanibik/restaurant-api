MenuItem.delete_all
Restaurant.delete_all

# =============================
# Restaurant 1
# =============================

r1 = Restaurant.create!(
  name: "Bangkok Street Kitchen",
  address: "Sukhumvit Road, Bangkok",
  phone: "+66 812345678",
  opening_hours: "10:00 - 22:00"
)

MenuItem.create!([
  {
    restaurant: r1,
    name: "Spring Rolls",
    description: "Crispy vegetable spring rolls served with sweet chili sauce",
    price: 120,
    category: "appetizer"
  },
  {
    restaurant: r1,
    name: "Chicken Satay",
    description: "Grilled chicken skewers with peanut sauce",
    price: 150,
    category: "appetizer"
  },
  {
    restaurant: r1,
    name: "Pad Thai",
    description: "Stir-fried rice noodles with shrimp, egg, tofu, and peanuts",
    price: 180,
    category: "main"
  },
  {
    restaurant: r1,
    name: "Green Curry Chicken",
    description: "Chicken cooked in green curry with coconut milk and basil",
    price: 200,
    category: "main"
  },
  {
    restaurant: r1,
    name: "Thai Fried Rice",
    description: "Fried rice with chicken, egg, vegetables, and fish sauce",
    price: 160,
    category: "main"
  },
  {
    restaurant: r1,
    name: "Mango Sticky Rice",
    description: "Sweet sticky rice served with fresh mango and coconut milk",
    price: 140,
    category: "dessert"
  },
  {
    restaurant: r1,
    name: "Thai Iced Tea",
    description: "Traditional Thai tea with milk and ice",
    price: 60,
    category: "drink"
  },
  {
    restaurant: r1,
    name: "Coconut Water",
    description: "Fresh coconut water served chilled",
    price: 70,
    category: "drink"
  }
])

# =============================
# Restaurant 2
# =============================

r2 = Restaurant.create!(
  name: "Chiang Mai Spice House",
  address: "Nimmanhaemin Road, Chiang Mai",
  phone: "+66 823456789",
  opening_hours: "09:00 - 21:30"
)

MenuItem.create!([
  {
    restaurant: r2,
    name: "Papaya Salad (Som Tam)",
    description: "Spicy green papaya salad with lime, fish sauce, and peanuts",
    price: 130,
    category: "appetizer"
  },
  {
    restaurant: r2,
    name: "Tom Yum Soup",
    description: "Hot and sour shrimp soup with lemongrass and lime",
    price: 170,
    category: "appetizer"
  },
  {
    restaurant: r2,
    name: "Khao Soi",
    description: "Northern Thai coconut curry noodle soup with chicken",
    price: 190,
    category: "main"
  },
  {
    restaurant: r2,
    name: "Massaman Curry",
    description: "Rich curry with beef, potatoes, peanuts, and spices",
    price: 210,
    category: "main"
  },
  {
    restaurant: r2,
    name: "Basil Chicken (Pad Kra Pao)",
    description: "Stir-fried chicken with basil and chili served with rice",
    price: 170,
    category: "main"
  },
  {
    restaurant: r2,
    name: "Coconut Ice Cream",
    description: "Homemade coconut ice cream topped with peanuts",
    price: 120,
    category: "dessert"
  },
  {
    restaurant: r2,
    name: "Lemongrass Drink",
    description: "Refreshing lemongrass herbal drink",
    price: 65,
    category: "drink"
  },
  {
    restaurant: r2,
    name: "Thai Milk Tea",
    description: "Sweet milk tea served with crushed ice",
    price: 60,
    category: "drink"
  }
])

# =============================
# Restaurant 3
# =============================

r3 = Restaurant.create!(
  name: "Phuket Seafood Grill",
  address: "Patong Beach Road, Phuket",
  phone: "+66 834567890",
  opening_hours: "11:00 - 23:00"
)

MenuItem.create!([
  {
    restaurant: r3,
    name: "Grilled Prawns",
    description: "Fresh prawns grilled with garlic butter",
    price: 320,
    category: "main"
  },
  {
    restaurant: r3,
    name: "Seafood Tom Yum",
    description: "Spicy and sour soup with mixed seafood",
    price: 240,
    category: "appetizer"
  },
  {
    restaurant: r3,
    name: "Grilled Squid",
    description: "Charcoal grilled squid served with seafood sauce",
    price: 260,
    category: "main"
  },
  {
    restaurant: r3,
    name: "Fish Sauce Fried Rice",
    description: "Fried rice flavored with fish sauce and seafood",
    price: 200,
    category: "main"
  },
  {
    restaurant: r3,
    name: "Seafood Green Curry",
    description: "Mixed seafood cooked in green curry coconut sauce",
    price: 250,
    category: "main"
  },
  {
    restaurant: r3,
    name: "Fried Banana",
    description: "Deep fried banana with honey and sesame",
    price: 110,
    category: "dessert"
  },
  {
    restaurant: r3,
    name: "Fresh Lime Soda",
    description: "Sparkling soda with fresh lime juice",
    price: 70,
    category: "drink"
  },
  {
    restaurant: r3,
    name: "Iced Coconut Latte",
    description: "Coffee latte with coconut milk and ice",
    price: 90,
    category: "drink"
  }
])

puts "Seed data created successfully!"