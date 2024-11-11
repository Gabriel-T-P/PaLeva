require 'rails_helper'

describe 'usuário abre página de configurações' do
  it 'pela sidebar no nome do usuário' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: 'Rio Branco, Deodoro', user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    login_as user
    visit root_path
    
    expect(page).to have_content 'Configurações da Conta'
    expect(page).to have_link 'Perfil'
    expect(page).to have_link 'Configurações'
    expect(page).to have_button 'Sair'
  end
  
end
