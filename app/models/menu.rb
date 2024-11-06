class Menu < ApplicationRecord
  has_many :item_menus
  has_many :items, through: :item_menus
end
