class MenuItem < ApplicationRecord
  belongs_to :restaurant

  validates :name, presence: true
  validates :price, presence: true
end
