require 'rails_helper'

describe 'usuário atualiza uma porção' do
  context 'pelas bebidas' do
    it 'mas não pertence àquele estabelecimento' do
      establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", cnpj: CNPJ.generate, 
                                            email: 'teste123@email.com', phone_number: '99999043113')
      beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment1, alcoholic: true)
      portion = Portion.create!(name: 'Teste', description: 'Testando', price: 7.50, item: beverage)
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
  
      login_as user2
      patch set_unactive_establishment_beverage_portion_path(establishment1, beverage, portion)
  
      expect(response).to redirect_to root_path(locale: I18n.locale)
    end
  
    it 'e não está logado' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)
      portion = Portion.create!(name: 'Teste', description: 'Testando', price: 7.50, item: beverage)
      
      patch set_unactive_establishment_beverage_portion_path(establishment, beverage, portion)
      
      expect(response).to redirect_to new_user_session_path
    end
  
    it 'mas não é admin do estabelecimento' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)
      portion = Portion.create!(name: 'Teste', description: 'Testando', price: 7.50, item: beverage)
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
      user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)
  
      login_as user2
      patch set_unactive_establishment_beverage_portion_path(establishment, beverage, portion)
  
      expect(response).to redirect_to root_path(locale: I18n.locale)
    end
  end
  
  context 'pelos pratos' do
    it 'mas não pertence àquele estabelecimento' do
      establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", cnpj: CNPJ.generate, 
                                            email: 'teste123@email.com', phone_number: '99999043113')
      dish = Item.create!(name: 'Pão', description: 'Pão fresco', calories: '140', item_type: 'dish', establishment: establishment1)
      portion = Portion.create!(name: 'Teste', description: 'Testando', price: 7.50, item: dish)
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
  
      login_as user2
      patch set_unactive_establishment_item_portion_path(establishment1, dish, portion)
  
      expect(response).to redirect_to root_path(locale: I18n.locale)
    end
  
    it 'e não está logado' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      dish = Item.create!(name: 'Pão', description: 'Pão fresco', calories: '140', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Teste', description: 'Testando', price: 7.50, item: dish)
      
      patch set_unactive_establishment_item_portion_path(establishment, dish, portion)
      
      expect(response).to redirect_to new_user_session_path
    end
  
    it 'mas não é admin do estabelecimento' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      dish = Item.create!(name: 'Pão', description: 'Pão fresco', calories: '140', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Teste', description: 'Testando', price: 7.50, item: dish)
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
      user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)
  
      login_as user2
      patch set_unactive_establishment_item_portion_path(establishment, dish, portion)

      expect(response).to redirect_to root_path(locale: I18n.locale)
    end
  end
end
