require 'rails_helper'

describe 'usuário edita uma bebida' do
  it 'mas não pertence àquele estabelecimento' do
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", cnpj: CNPJ.generate, 
                                          email: 'teste123@email.com', phone_number: '99999043113')
    opening_hour = OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment1)
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)

    login_as user2
    put establishment_opening_hour_path(establishment1, opening_hour), params: {
      opening_hour: {
        day_of_week: 2,
        establishment: establishment1,
        closed: true
      }
    }

    expect(response).to redirect_to root_path(locale: I18n.locale)
  end

  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    opening_hour = OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment)
    
    put establishment_opening_hour_path(establishment, opening_hour), params: {
      opening_hour: {
        day_of_week: 2,
        establishment: establishment,
        closed: true
      }
    }
    
    expect(response).to redirect_to new_user_session_path
  end

  it 'mas não é admin do estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    opening_hour = OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment)
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
    user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)

    login_as user2
    put establishment_opening_hour_path(establishment, opening_hour), params: {
      opening_hour: {
        day_of_week: 2,
        establishment: establishment,
        closed: true
      }
    }

    expect(response).to redirect_to root_path(locale: I18n.locale)
  end
end
