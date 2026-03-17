class MenuItem < ApplicationRecord
  # Daftar kategori yang diizinkan untuk konsistensi data.
  CATEGORIES = %w[appetizer main dessert drink].freeze

  # Setiap menu item harus terhubung ke satu restoran.
  belongs_to :restaurant

  # Validasi dasar untuk mencegah data menu yang tidak valid.
  validates :name, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :is_available, inclusion: { in: [true, false] }
end
