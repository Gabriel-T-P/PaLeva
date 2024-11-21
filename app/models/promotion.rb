class Promotion < ApplicationRecord
  has_many :portions

  validates :name, :percentage, :start_date, :end_date, presence: true
  
  
end
