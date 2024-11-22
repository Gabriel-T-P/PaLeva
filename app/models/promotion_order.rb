class PromotionOrder < ApplicationRecord
  belongs_to :promotion
  belongs_to :order
end
