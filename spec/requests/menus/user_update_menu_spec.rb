require 'rails_helper'

describe 'usuário atualiza cardápio' do
  it 'com sucesso' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)

    login_as user
    patch menu_path(menu), params: {
      menu: {
        name: 'Jantar'
      }
    }
    menu.reload

    expect(menu.name).to eq 'Jantar'    
  end

  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)
    
    patch menu_path(menu), params: {
      menu: {
        name: 'Jantar'
      }
    }
    menu.reload

    expect(response.status).to eq 302
    expect(response).to redirect_to new_user_session_path
    expect(menu.name).to eq 'Café da Manhã'  
  end
  
  it 'e não é admin do estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
    user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)

    login_as user2
    patch menu_path(menu), params: {
      menu: {
        name: 'Jantar'
      }
    }
    menu.reload

    expect(response.status).to eq 302
    expect(response).to redirect_to root_path(locale: I18n.locale)
    expect(menu.name).to eq 'Café da Manhã'  
  end
end
