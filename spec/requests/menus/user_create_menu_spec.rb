require 'rails_helper'

describe 'usuário cria cardápio' do
  it 'com sucesso' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)

    login_as user
    post menus_path, params: {
      menu: {
        establishment: establishment,
        name: 'Jantar'
      }
    }

    expect(Menu.count).to eq 1  
  end
  
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    post menus_path, params: {
      menu: {
        establishment: establishment,
        name: 'Jantar'
      }
    }
    
    expect(response.status).to eq 302
    expect(response).to redirect_to new_user_session_path
    expect(Menu.count).to eq 0  
  end
  
  it 'e não é admin do estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
    user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)

    login_as user2
    post menus_path, params: {
      menu: {
        establishment: establishment,
        name: 'Jantar'
      }
    }

    expect(response).to redirect_to root_path(locale: I18n.locale)
    expect(response.status).to eq 302
    expect(Menu.count).to eq 0  
  end
end
