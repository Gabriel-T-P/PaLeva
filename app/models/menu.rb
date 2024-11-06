class Menu < ApplicationRecord
  has_many :item_menus, dependent: :destroy
  has_many :items, through: :item_menus

  validates :name, presence: true
  validates :name, uniqueness: { scope: :establishment_id }
  
end
