class OpeningHour < ApplicationRecord
  belongs_to :establishment

  validates :day_of_week, inclusion: { in: 0..6 }
  validates :day_of_week, uniqueness: { scope: :establishment_id, message: I18n.t('day_already_used') }
  validates :opening_time, :closing_time, :day_of_week, presence: true, if: :open_today?
  validates :closed, inclusion: [true, false]

  def open_today?
    !closed
  end

end
