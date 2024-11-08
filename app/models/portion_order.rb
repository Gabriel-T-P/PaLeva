class PortionOrder < ApplicationRecord
  belongs_to :portion
  belongs_to :order

  validates :quantity, numericality: { only_integer: true }
  validates :observation, length: { minimum: 6, too_short: :too_short }, allow_blank: true

end
