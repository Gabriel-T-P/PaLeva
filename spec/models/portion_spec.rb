require 'rails_helper'

RSpec.describe Portion, type: :model do
  describe '#valid?' do
    context 'quando pelos pratos' do
      it 'Nome estiver presente' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)

        result = portion.valid?

        expect(result).to be true  
      end
      
      it 'Nome estiver ausente' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.new(name: '', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)

        result = portion.valid?

        expect(result).to be false
      end
      
      it 'Descrição estiver ausente' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.new(name: 'Meia Lasanha', description: '', price: 7.50, item: dish)

        result = portion.valid?

        expect(result).to be false  
      end
      
      it 'Preço estiver ausente' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', item: dish)

        result = portion.valid?

        expect(result).to be false
      end
      
      it 'Preço não for numérico' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 'aba', item: dish)

        result = portion.valid?

        expect(result).to be false
      end

      it 'Preço for negativo' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: -7.50, item: dish)

        result = portion.valid?

        expect(result).to be false
      end
      

      it 'Item estiver ausente' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50)

        result = portion.valid?

        expect(result).to be false  
      end

      it 'Ativo for true' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish, active: true)

        result = portion.valid?

        expect(result).to be true
      end
      
      it 'Ativo for false' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish, active: false)

        result = portion.valid?

        expect(result).to be false
      end
    end
    
    context 'quando pelas bebidas' do
      it 'Nome estiver presente' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        beverage = Beverage.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'beverage', establishment: establishment, alcoholic: false)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: beverage)

        result = portion.valid?

        expect(result).to be true  
      end
      
      it 'Nome estiver ausente' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        beverage = Beverage.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'beverage', establishment: establishment, alcoholic: false)
        portion = Portion.new(name: '', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: beverage)

        result = portion.valid?

        expect(result).to be false
      end
      
      it 'Descrição estiver ausente' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        beverage = Beverage.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'beverage', establishment: establishment, alcoholic: false)
        portion = Portion.new(name: 'Meia Lasanha', description: '', price: 7.50, item: beverage)

        result = portion.valid?

        expect(result).to be false  
      end
      
      it 'Preço estiver ausente' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        beverage = Beverage.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'beverage', establishment: establishment, alcoholic: false)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', item: beverage)

        result = portion.valid?

        expect(result).to be false
      end
      
      it 'Preço não for numérico' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        beverage = Beverage.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'beverage', establishment: establishment, alcoholic: false)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 'aba', item: beverage)

        result = portion.valid?

        expect(result).to be false
      end

      it 'Preço for negativo' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        beverage = Beverage.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'beverage', establishment: establishment, alcoholic: false)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: -7.50, item: beverage)

        result = portion.valid?

        expect(result).to be false
      end
      

      it 'Item estiver ausente' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        beverage = Beverage.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'beverage', establishment: establishment, alcoholic: false)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50)

        result = portion.valid?

        expect(result).to be false  
      end

      it 'Ativo for true' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        beverage = Beverage.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'beverage', establishment: establishment, alcoholic: false)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: beverage, active: true)

        result = portion.valid?

        expect(result).to be true
      end
      
      it 'Ativo for false' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        beverage = Beverage.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'beverage', establishment: establishment, alcoholic: false)
        portion = Portion.new(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: beverage, active: false)

        result = portion.valid?

        expect(result).to be false
      end
    end
  end
end
