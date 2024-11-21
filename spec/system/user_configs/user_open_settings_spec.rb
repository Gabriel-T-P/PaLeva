require 'rails_helper'

describe 'usuário abre página de configurações' do
  it 'pela sidebar no nome do usuário' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: 'Rio Branco, Deodoro', cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    
    login_as user
    visit root_path
    
    within '#UserSidebar' do
      expect(page).to have_content 'Configurações'
      expect(page).to have_link 'Cardápio'
      expect(page).to have_link 'Marcador'
      expect(page).to have_button 'Sair'      
    end
  end
  
  it 'e não admin não vê alguns links' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: 'Rio Branco, Deodoro', cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = Employee.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    
    login_as user
    visit root_path
    
    expect(page).to have_content 'Configurações'
    expect(page).not_to have_link 'Cardápio'
    expect(page).not_to have_link 'Marcador'
    expect(page).to have_button 'Sair'
  end
end
