class OpeningHour < ApplicationRecord
  belongs_to :establishment

  validates :day_of_week, inclusion: { in: 0..6 }
  validates :opening_time, :closing_time, :day_of_week, presence: true, if: :open_today?

  private

  def open_today?
    !closed
  end

end
