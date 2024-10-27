class Beverage < Item
  validates :alcoholic, inclusion: [true, false]
end