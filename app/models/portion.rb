class Portion < ApplicationRecord
  belongs_to :item
  has_one_attached :image

  validates :name, :description, presence: true
  validates :price, numericality: true
  
end
