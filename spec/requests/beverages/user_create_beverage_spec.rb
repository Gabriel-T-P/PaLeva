require 'rails_helper'

describe 'usuário cria uma bebida' do
  it 'e não é o dono' do
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user1, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", user: user2, cnpj: CNPJ.generate, 
                                          email: 'teste123@email.com', phone_number: '99999043113')

    login_as user2
    post establishment_beverages_path(establishment1), params: {
      beverage: {
        name: 'Água',
        description: 'Água Mineral',
        calories: '140',
        item_type: 'beverage',
        establishment: establishment1,
        alcoholic: false
      }
    }

    expect(response).to redirect_to(root_path)
  end
  
  it 'e não é admin do estabelecimento' do
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user1, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')

    login_as user2
    post establishment_beverages_path(establishment), params: {
      beverage: {
        name: 'Água',
        description: 'Água Mineral',
        calories: '140',
        item_type: 'beverage',
        establishment: establishment,
        alcoholic: false
      }
    }

    expect(response).to redirect_to(root_path)
  end
  
end
