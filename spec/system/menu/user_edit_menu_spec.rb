require 'rails_helper'

describe 'usuário edita cardápio' do
  it 'pela sidebar do usuário' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado', calories: '100', item_type: 'dish', establishment: establishment)
    beverage = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)
    menu.items<<[dish, beverage]

    login_as user
    visit root_path
    within '#UserSidebar' do
      click_on 'Cardápio'
    end
    click_on 'Editar'

    expect(page).to have_content 'Editar Cardápio'  
    expect(page).to have_field 'Nome'  
    expect(page).to have_field 'Data de Início'  
    expect(page).to have_field 'Data de Fim'  
    expect(page).to have_field 'Pão de Queijo'  
    expect(page).to have_field 'Suco de Laranja'
  end
  
  it 'e usuário não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)

    visit edit_menu_path(menu)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'  
  end

  it 'e usuário não é admin' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = Employee.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)

    login_as user
    visit edit_menu_path(menu)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'    
  end

  it 'e clica em cancelar' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)

    login_as user
    visit edit_menu_path(menu)
    click_on 'Cancelar'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Café da Manhã'
  end
  
  it 'com sucesso' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado', calories: '100', item_type: 'dish', establishment: establishment)
    beverage = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)
    menu.items<<[dish, beverage]

    login_as user
    visit edit_menu_path(menu)
    fill_in 'Nome',	with: 'Lanche da Tarde'
    fill_in 'Data de Início', with: 1.day.ago.to_date
    fill_in 'Data de Fim', with: 2.days.from_now.to_date
    uncheck 'Pão de Queijo'
    click_on 'Salvar Cardápio'

    expect(current_path).to eq root_path  
    expect(page).to have_content 'Lanche da Tarde'  
    expect(page).to have_content 'Suco de Laranja'
    expect(page).to have_content "Disponível entre os dias: #{I18n.l(1.day.ago.to_date)} até #{I18n.l(2.days.from_now.to_date)}"
    expect(page).not_to have_content 'Café da Manhã'  
    expect(page).not_to have_content 'Pão de Queijo'
  end
end
