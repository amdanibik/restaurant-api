class Restaurant < ApplicationRecord
  has_many :menu_items, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
  validates :phone, length: { maximum: 30 }, allow_blank: true
  validates :opening_hours, length: { maximum: 100 }, allow_blank: true
end
