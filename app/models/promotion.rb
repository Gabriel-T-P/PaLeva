class Promotion < ApplicationRecord
  has_many :portions

  validates :name, :percentage, :start_date, :end_date, presence: true
  validates :percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :use_limit, numericality: { greater_than_or_equal_to: 0, only_integer: true, allow_nil: true }

  
end
