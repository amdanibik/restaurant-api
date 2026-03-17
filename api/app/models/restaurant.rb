class Restaurant < ApplicationRecord
  # Satu restoran punya banyak menu item.
  # Jika restoran dihapus, menu item terkait ikut dihapus.
  has_many :menu_items, dependent: :destroy

  # Field inti restoran wajib diisi.
  validates :name, presence: true
  validates :address, presence: true

  # Field opsional tetap dibatasi panjang untuk menjaga kualitas data.
  validates :phone, length: { maximum: 30 }, allow_blank: true
  validates :opening_hours, length: { maximum: 100 }, allow_blank: true
end
