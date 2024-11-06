require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#valid?' do
    it 'quando Nome estiver presente' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      menu = Menu.new(name: 'Almoço', establishment: establishment)
      
      result = menu.valid?

      expect(result).to be true  
    end
    
    it 'quando Nome estiver ausente' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      menu = Menu.new(name: '', establishment: establishment)
      
      result = menu.valid?

      expect(result).to be false 
    end
    
    it 'quando Nome já estiver sendo usado dentro do estabelecimento' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      other_menu = Menu.create!(name: 'Almoço', establishment: establishment)
      menu = Menu.new(name: 'Almoço', establishment: establishment)
      
      result = menu.valid?

      expect(result).to be false
    end
    
    it 'quando mesmo Nome estiver sendo usando entre estabelecimentos' do
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
      establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user1, 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: 'Teste Lunch', full_address: "Av testes, 123", user: user2, 
                                              cnpj: CNPJ.generate, email: 'teste123546@email.com', phone_number: '99999043113')
      menu = Menu.create!(name: 'Almoço', establishment: establishment1)
      other_menu = Menu.new(name: 'Almoço', establishment: establishment2)
      
      result = menu.valid?

      expect(result).to be true
    end
  end
end
