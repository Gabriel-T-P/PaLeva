class Dish < Item
  validates :alcoholic, absence: true
end