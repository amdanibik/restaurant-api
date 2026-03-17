class AddIndexesToRestaurantsAndMenuItems < ActiveRecord::Migration[7.0]
  def change
    add_index :restaurants, :name
    add_index :menu_items, [:restaurant_id, :category], name: "index_menu_items_on_restaurant_id_and_category"
    add_index :menu_items, [:restaurant_id, :name], name: "index_menu_items_on_restaurant_id_and_name"
  end
end