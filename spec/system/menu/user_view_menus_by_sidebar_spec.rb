require 'rails_helper'

describe 'usuário vê cardápio pela navegação na sidebar' do
  it 'e vê todos os cardápios' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    Menu.create!(name: 'Teste 1', establishment: establishment)
    Menu.create!(name: 'Teste 2', establishment: establishment)
    Menu.create!(name: 'Teste 3', establishment: establishment)

    login_as user
    visit root_path
    within '#UserSidebar' do      
      click_on 'Cardápio'
    end

    expect(page).to have_content 'Teste 1'  
    expect(page).to have_content 'Teste 2'
    expect(page).to have_content 'Teste 3'
  end
  
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    visit menus_path

    expect(current_path).to eq new_user_session_path  
  end
  
  it 'e não é admin' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = Employee.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    
    login_as user
    visit menus_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'    
  end
  
end
