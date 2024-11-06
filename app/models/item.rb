class Item < ApplicationRecord
  belongs_to :establishment
  has_many :portions
  has_many :item_tags
  has_many :tags, through: :item_tags
  has_many :item_menus
  has_many :menus, through: :item_menus
  has_one_attached :image

  validates :name, :description, :calories, :item_type, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :calories, numericality: { only_integer: true }  
  

  enum :item_type, { :dish => 2, :beverage => 5 }
end
