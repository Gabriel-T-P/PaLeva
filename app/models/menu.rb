class Menu < ApplicationRecord
  has_many :item_menus, dependent: :destroy
  has_many :items, through: :item_menus
  belongs_to :establishment

  validates :name, presence: true
  validates :name, uniqueness: { scope: :establishment_id }
  validates :start_date, presence: true, if: -> {end_date.present?}
  validates :end_date, presence: true, if: -> {start_date.present?}
  validate :start_date_before_end_date

  def start_date_before_end_date
    errors.add(:start_date, :before_end_date) if start_date.present? && end_date.present? && start_date >= end_date
    errors.add(:start_date, :start_date_different_end_date) if start_date.present? && end_date.present? && start_date == end_date
  end
  
end
