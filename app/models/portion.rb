class Portion < ApplicationRecord
  belongs_to :item
  belongs_to :promotion, optional: true
  has_one_attached :image
  has_many :price_histories, dependent: :destroy
  has_many :portion_orders
  has_many :orders, through: :portion_orders

  validates :name, :description, presence: true
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }
  validates :active, inclusion: [true], on: :create
  
  after_create :create_initial_price_history
  after_update :add_price_history, if: :saved_change_to_price?

  private

  def create_initial_price_history
    price_histories.create(price: price, current: true, added_at: Time.current)
  end
  
  def add_price_history
    price_histories.last.update(current: false, ended_at: Time.current)
    price_histories.create(price: price, current: true, added_at: Time.current)
  end

end
