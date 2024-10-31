class Portion < ApplicationRecord
  belongs_to :item
  has_one_attached :image

  validates :name, :description, presence: true
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }
  validates :active, inclusion: [true], on: :create
  
end
