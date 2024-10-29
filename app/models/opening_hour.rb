class OpeningHour < ApplicationRecord
  belongs_to :establishment

  validates :day_of_week, inclusion: { in: 0..6 }
  validates :day_of_week, uniqueness: { scope: :establishment_id, message: I18n.t('day_already_used') }
  validates :opening_time, :closing_time, :day_of_week, presence: true, if: :open_today?
  validates :closed, inclusion: [true, false]
  validate :opening_time_before_closing_time

  def open_today?
    !closed
  end

  def opening_time_before_closing_time
    errors.add(:opening_time, :before_closing_time) if opening_time.present? && closing_time.present? && opening_time >= closing_time
    errors.add(:opening_time, :opening_time_different_closing_time) if opening_time.present? && closing_time.present? && opening_time == closing_time
  end

end
