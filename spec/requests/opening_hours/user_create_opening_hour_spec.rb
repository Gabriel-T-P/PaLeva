require 'rails_helper'

describe 'usuário cria um horário de abertura' do
  it 'e não pertence àquele estabelecimento' do
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", cnpj: CNPJ.generate, 
                                          email: 'teste123@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)

    login_as user2
    post establishment_opening_hours_path(establishment1), params: {
      opening_hour: {
        day_of_week: 1,
        establishment: establishment1,
        closed: true
      }
    }

    expect(response).to redirect_to root_path(locale: I18n.locale)
  end
  
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    post establishment_opening_hours_path(establishment), params: {
      opening_hour: {
        day_of_week: 1,
        establishment: establishment,
        closed: true
      }
    }
    
    expect(response).to redirect_to new_user_session_path
  end
  
  it 'e não é admin do estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
    user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)

    login_as user2
    post establishment_opening_hours_path(establishment), params: {
      opening_hour: {
        day_of_week: 1,
        establishment: establishment,
        closed: true
      }
    }

    expect(response).to redirect_to root_path(locale: I18n.locale)
  end
end
