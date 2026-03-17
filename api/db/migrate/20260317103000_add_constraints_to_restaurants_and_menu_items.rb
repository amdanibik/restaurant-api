class AddConstraintsToRestaurantsAndMenuItems < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      UPDATE restaurants
      SET name = 'Unnamed Restaurant'
      WHERE name IS NULL
    SQL

    execute <<~SQL
      UPDATE restaurants
      SET address = 'Address unavailable'
      WHERE address IS NULL
    SQL

    execute <<~SQL
      UPDATE menu_items
      SET name = 'Unnamed Menu Item'
      WHERE name IS NULL
    SQL

    execute <<~SQL
      UPDATE menu_items
      SET price = 0.01
      WHERE price IS NULL
    SQL

    execute <<~SQL
      UPDATE menu_items
      SET category = 'main'
      WHERE category IS NULL
    SQL

    execute <<~SQL
      UPDATE menu_items
      SET is_available = TRUE
      WHERE is_available IS NULL
    SQL

    change_column_null :restaurants, :name, false
    change_column_null :restaurants, :address, false

    change_column_null :menu_items, :name, false
    change_column_null :menu_items, :price, false
    change_column_null :menu_items, :category, false
    change_column_default :menu_items, :is_available, from: nil, to: true
    change_column_null :menu_items, :is_available, false
  end

  def down
    change_column_null :restaurants, :name, true
    change_column_null :restaurants, :address, true

    change_column_null :menu_items, :name, true
    change_column_null :menu_items, :price, true
    change_column_null :menu_items, :category, true
    change_column_null :menu_items, :is_available, true
    change_column_default :menu_items, :is_available, from: true, to: nil
  end
end