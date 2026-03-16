class CreateMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_items do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.decimal :price
      t.string :category
      t.boolean :is_available

      t.timestamps
    end
  end
end
