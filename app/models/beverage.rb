class Beverage < Item
  validates :alcoholic, presence: true
  validates :alcoholic, inclusion: [true, false]
end