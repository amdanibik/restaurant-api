class MenuItem < ApplicationRecord
  CATEGORIES = %w[appetizer main dessert drink].freeze

  belongs_to :restaurant

  validates :name, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :is_available, inclusion: { in: [true, false] }
end
