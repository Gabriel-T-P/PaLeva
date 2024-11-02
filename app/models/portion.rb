class Portion < ApplicationRecord
  belongs_to :item
  has_one_attached :image
  has_many :price_histories, dependent: :destroy

  validates :name, :description, presence: true
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }
  validates :active, inclusion: [true], on: :create
  
  after_create :create_initial_price_history

  private

  def create_initial_price_history
    price_histories.create(price: price, current: true, added_at: Time.current)
  end
  
end
