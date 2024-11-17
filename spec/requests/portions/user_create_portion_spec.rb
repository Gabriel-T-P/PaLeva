require 'rails_helper'

describe 'usuário cria uma porção' do
  context 'pelos pratos' do
    it 'e não pertence àquele estabelecimento' do
      establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", cnpj: CNPJ.generate, 
                                            email: 'teste123@email.com', phone_number: '99999043113')
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
      dish = Item.create!(name: 'Pão', description: 'Pão fresco', calories: '140', item_type: 'dish', establishment: establishment1)
  
      login_as user2
      post establishment_item_portions_path(establishment1, dish), params: {
        portion: {
          name: 'Teste',
          description: 'Testando',
          price: 2.00
        }
      }
  
      expect(response).to redirect_to root_path(locale: I18n.locale)
    end
    
    it 'e não está logado' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      dish = Item.create!(name: 'Pão', description: 'Pão fresco', calories: '140', item_type: 'dish', establishment: establishment)
      
      post establishment_item_portions_path(establishment, dish), params: {
        portion: {
          name: 'Teste',
          description: 'Testando',
          price: 2.00
        }
      }
      
      expect(response).to redirect_to new_user_session_path
    end
    
    it 'e não é admin do estabelecimento' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
      user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)
      dish = Item.create!(name: 'Pão', description: 'Pão fresco', calories: '140', item_type: 'dish', establishment: establishment)
  
      login_as user2
      post establishment_item_portions_path(establishment, dish), params: {
        portion: {
          name: 'Teste',
          description: 'Testando',
          price: 2.00
        }
      }
  
      expect(response).to redirect_to root_path(locale: I18n.locale)
    end
  end
  
  context 'pelas bebidas' do
    it 'e não pertence àquele estabelecimento' do
      establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", cnpj: CNPJ.generate, 
                                            email: 'teste123@email.com', phone_number: '99999043113')
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
      beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment1, alcoholic: true)
  
      login_as user2
      post establishment_beverage_portions_path(establishment1, beverage), params: {
        portion: {
          name: 'Teste',
          description: 'Testando',
          price: 2.00
        }
      }
  
      expect(response).to redirect_to root_path(locale: I18n.locale)
    end
    
    it 'e não está logado' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)
      
      post establishment_beverage_portions_path(establishment, beverage), params: {
        portion: {
          name: 'Teste',
          description: 'Testando',
          price: 2.00
        }
      }
      
      expect(response).to redirect_to new_user_session_path
    end
    
    it 'e não é admin do estabelecimento' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
      user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)
      beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)
  
      login_as user2
      post establishment_beverage_portions_path(establishment, beverage), params: {
        portion: {
          name: 'Teste',
          description: 'Testando',
          price: 2.00
        }
      }
  
      expect(response).to redirect_to root_path(locale: I18n.locale)
    end
  end
end
