require 'rails_helper'

RSpec.describe PriceHistory, type: :model do
  describe '#create_initial_price_history' do
    context 'quando nova portion é criada' do
      it 'price history existe' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Lasanha Grande', description: 'Lasanha de carne, serve 4 pessoas', price: '52.00', item: dish)
  
        result = portion.price_histories
  
        expect(result.empty?).to be false
      end
      
      it 'price history tem o mesmo price que a portion' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Lasanha Grande', description: 'Lasanha de carne, serve 4 pessoas', price: '52.00', item: dish)
  
        result = portion.price_histories.first

        expect(result.price).to eq portion.price
      end
    end
  end
  
end
