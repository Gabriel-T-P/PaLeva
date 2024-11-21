require 'rails_helper'

RSpec.describe Promotion, type: :model do
  describe '#valid?' do
    context 'quando Nome' do
      it 'estiver ausente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: '', percentage: 0.75, use_limit: 20, start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])

        result = promotion.valid?

        expect(result).to be false  
      end
      
    end
    
    context 'quando Porcentagem' do
      it 'estiver ausente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: '', use_limit: 20, start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])
        
        result = promotion.valid?

        expect(result).to be false  
      end
      
      it 'não for um número' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 'asdaw', use_limit: 20, start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])
        
        result = promotion.valid?

        expect(result).to be false  
      end
      
      it 'for menor do que 0' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: -1, use_limit: 20, start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])
        
        result = promotion.valid?

        expect(result).to be false  
      end
      
      it 'for maior do que 1' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 2, use_limit: 20, start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])
        
        result = promotion.valid?

        expect(result).to be false
      end
    end
    
    context 'quando Limite de Uso' do
      it 'estiver ausente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: '', start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])
        
        result = promotion.valid?

        expect(result).to be true
      end

      it 'não for um número' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: 'avad', start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])
        
        result = promotion.valid?

        expect(result).to be false
      end
      
      it 'não for um número inteiro' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: 1.5, start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])
        
        result = promotion.valid?

        expect(result).to be false
      end
      
      it ' for um número menor que 0' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: -1, start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])
        
        result = promotion.valid?

        expect(result).to be false
      end
    end
    
    context 'quando Data de Início' do
      it 'estiver ausente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: 20, start_date: '', end_date: 1.day.from_now.to_date, portions: [portion])
        
        result = promotion.valid?

        expect(result).to be false
      end
      
      it 'não for uma data' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: 20, start_date: 'awdwa', end_date: 1.day.from_now.to_date, portions: [portion])
        
        result = promotion.valid?

        expect(result).to be false
      end
      
      it 'for marcada para depois de Data de Fim' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: 20, start_date: 1.week.from_now.to_date, portions: [portion], end_date: Date.current)
        
        result = promotion.valid?

        expect(result).to be false
      end
      
      it 'for igual a Data de Fim' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: 20, start_date: Date.current, end_date: Date.current, portions: [portion])
        
        result = promotion.valid?

        expect(result).to be false
      end
    end
    
    context 'quando Data de Fim' do
      it 'estiver ausente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: 20, start_date: Date.current, end_date: '', portions: [portion])
        
        result = promotion.valid?

        expect(result).to be false
      end
    end
    
    context 'quando Porções' do
      it 'estiverem ausentes' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: 20, start_date: Date.current, end_date: 1.day.from_now.to_date)
        
        result = promotion.valid?

        expect(result).to be false
      end
    end
    
    it 'quando estiver tudo certo' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
      promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: 20, start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])
      
      result = promotion.valid?

      expect(result).to be true
    end
  end
end
