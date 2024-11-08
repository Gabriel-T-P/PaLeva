class Order < ApplicationRecord
  belongs_to :user
  has_many :portion_orders
  has_many :portions, through: :portion_orders

  enum :status, { :open => 2, :canceled => 5, :waiting_cook_confirmation => 7, :cooking => 9, :ready => 11, :delivered => 13 }
  after_initialize :set_default_status, :if => :new_record?


  private

  def set_default_status
    self.status ||= :open
  end

end
