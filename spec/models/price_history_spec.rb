require 'rails_helper'

RSpec.describe PriceHistory, type: :model do
  describe '#create_initial_price_history' do
    context 'quando nova portion é criada' do
      it 'price history existe' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Lasanha Grande', description: 'Lasanha de carne, serve 4 pessoas', price: '52.00', item: dish)
  
        result = portion.price_histories
  
        expect(result.empty?).to be false
      end
      
      it 'price history tem o mesmo price que a portion' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Lasanha Grande', description: 'Lasanha de carne, serve 4 pessoas', price: '52.00', item: dish)
  
        result = portion.price_histories.first

        expect(result.price).to eq portion.price
      end
    end
  end
  
  describe '#add_price_history' do
    it 'segundo price history existe' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Lasanha Grande', description: 'Lasanha de carne, serve 4 pessoas', price: '52.00', item: dish)
      portion.update(price: '50.00')

      result = portion.price_histories

      expect(result.size).to eq 2
    end
    
    it 'segundo price history tem o mesmo price que a nova portion' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Lasanha Grande', description: 'Lasanha de carne, serve 4 pessoas', price: '52.00', item: dish)
      portion.update(price: '50.00')

      result = portion.price_histories.last

      expect(result.price).to eq portion.price
    end

    it 'segundo price history é o único com current true' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Lasanha Grande', description: 'Lasanha de carne, serve 4 pessoas', price: '52.00', item: dish)
      portion.update(price: '50.00')

      result1 = portion.price_histories.first
      result2 = portion.price_histories.last

      expect(result1.current).to be false
      expect(result2.current).to be true
    end

    it 'so cria novo price history se for update no price da porção' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Lasanha Grande', description: 'Lasanha de carne, serve 4 pessoas', price: '52.00', item: dish)
      portion.update(name: 'Lasanha BIG')

      result = portion.price_histories.size

      expect(result).to eq 1  
    end
  end
end
