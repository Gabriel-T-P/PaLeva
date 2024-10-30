class Portion < ApplicationRecord
  belongs_to :item
  has_one_attached :image

  validates :name, :description, :price, presence: true
  
end
