class Promotion < ApplicationRecord
  has_many :portions

  after_validation  :convert_percentage

  validates :name, :percentage, :start_date, :end_date, :portions, presence: true
  validates :percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :use_limit, numericality: { greater_than_or_equal_to: 0, only_integer: true, allow_nil: true }
  validates :start_date, comparison: { less_than: :end_date }


  private

  def convert_percentage
    self.percentage = percentage.to_f / 100 if percentage.present? && percentage > 1
  end
  
end
