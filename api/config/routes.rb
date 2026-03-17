Rails.application.routes.draw do
  # RestaurantsController
  post   "/restaurants",     to: "restaurants#create"
  get    "/restaurants",     to: "restaurants#index"
  get    "/restaurants/:id", to: "restaurants#show"
  put    "/restaurants/:id", to: "restaurants#update"
  patch  "/restaurants/:id", to: "restaurants#update"
  delete "/restaurants/:id", to: "restaurants#destroy"

  # MenuItemsController
  post   "/restaurants/:restaurant_id/menu_items", to: "menu_items#create"
  get    "/restaurants/:restaurant_id/menu_items", to: "menu_items#index"
  put    "/menu_items/:id",                         to: "menu_items#update"
  patch  "/menu_items/:id",                         to: "menu_items#update"
  delete "/menu_items/:id",                         to: "menu_items#destroy"
end
