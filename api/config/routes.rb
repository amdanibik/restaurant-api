Rails.application.routes.draw do
  resources :restaurants do
    resources :menu_items, only: [:create, :index]
  end

  resources :menu_items, only: [:update, :destroy]
end
