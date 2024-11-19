require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#valid?' do
    context 'quando Nome' do
      it 'estiver presente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        menu = Menu.new(name: 'Almoço', establishment: establishment)
        
        result = menu.valid?
  
        expect(result).to be true  
      end
      
      it 'estiver ausente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        menu = Menu.new(name: '', establishment: establishment)
        
        result = menu.valid?
  
        expect(result).to be false 
      end
      
      it 'já estiver sendo usado dentro do estabelecimento' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        other_menu = Menu.create!(name: 'Almoço', establishment: establishment)
        menu = Menu.new(name: 'Almoço', establishment: establishment)
        
        result = menu.valid?
  
        expect(result).to be false
      end
      
      it 'já estiver sendo usando entre estabelecimentos' do
        establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: 'Teste Lunch', full_address: "Av testes, 123", 
                                                cnpj: CNPJ.generate, email: 'teste123546@email.com', phone_number: '99999043113')
        user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
        user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
        menu = Menu.create!(name: 'Almoço', establishment: establishment1)
        other_menu = Menu.new(name: 'Almoço', establishment: establishment2)
        
        result = menu.valid?
  
        expect(result).to be true
      end
    end 

    context 'quando Data de Início ou Data de Fim' do
      it 'estiver presente e somente uma delas' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        menu = Menu.new(name: 'Almoço', establishment: establishment, start_date: Date.today)
        
        result = menu.valid?
  
        expect(result).to be false
      end

      it 'estiver antes da Data de Fim' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        menu = Menu.new(name: 'Almoço', establishment: establishment, start_date: Date.today, end_date: 2.weeks.from_now.to_date)
        
        result = menu.valid?
  
        expect(result).to be true
      end
      
      it 'estiver depois da Data de Fim' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        menu = Menu.new(name: 'Almoço', establishment: establishment, start_date: 2.weeks.from_now.to_date, end_date: Date.today)
        
        result = menu.valid?
  
        expect(result).to be false
      end
      
      it 'forem iguais' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        menu = Menu.new(name: 'Almoço', establishment: establishment, start_date: Date.today, end_date: Date.today)
        
        result = menu.valid?
  
        expect(result).to be false
      end
    end
  end
end
