require 'rails_helper'

describe 'usuário cadastra cardápio' do
  it 'pela navegação' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    login_as user
    visit root_path
    within 'nav' do
      click_on 'Cadastros'
      click_on 'Cardápios'
    end

    expect(page).to have_content 'Criar Cardápio'
    expect(page).to have_field 'Nome'
    expect(page).to have_content 'Pratos para o cardápio'
    expect(page).to have_content 'Bebidas para o cardápio'
    expect(page).to have_button 'Salvar Cardápio'  
  end
  
  it 'e usuário não logado não vê botão cadastros de cardápios' do
    visit root_path

    within 'nav' do
      expect(page).not_to have_button 'Cadastros'  
    end
  end
  
  it 'e usuário não logado' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    visit new_menu_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'  
  end
  
  it 'e cancela' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')

    login_as user
    visit new_menu_path
    click_on 'Cancelar'

    expect(current_path).to eq root_path
  end
  

  it 'e esperá ver pratos e bebidas para cadastro' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish1 = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
    dish2 = Item.create!(name: 'Macarronada', description: 'Carne moída, macarrão e molho picante', calories: '320', item_type: 'dish', establishment: establishment)
    beverage1 = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                            establishment: establishment, alcoholic: false)
    beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                            establishment: establishment, alcoholic: false)

    login_as user
    visit new_menu_path

    expect(page).to have_field 'Lasanha'  
    expect(page).to have_field 'Macarronada'  
    expect(page).to have_field 'Limonada'
    expect(page).to have_field 'Suco de Laranja'
  end
  

  it 'com sucesso' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish1 = Item.create!(name: 'Pão de Queijo', description: 'Polvilho, queijo', calories: '140', item_type: 'dish', establishment: establishment)
    beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)

    login_as user
    visit new_menu_path
    fill_in 'Nome',	with: 'Café da Manhã'
    check 'Suco de Laranja'
    check 'Pão de Queijo'
    click_on 'Salvar Cardápio'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Café da Manhã'
    expect(page).to have_content 'Suco de Laranja'
    expect(page).to have_content 'Pão de Queijo'
  end
  
  it 'e não vê itens que não foram marcados' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish1 = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
    dish2 = Item.create!(name: 'Macarronada', description: 'Carne moída, macarrão e molho picante', calories: '320', item_type: 'dish', establishment: establishment)
    beverage1 = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
    beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)

    login_as user
    visit new_menu_path
    fill_in 'Nome',	with: 'Café da Manhã'
    check 'Suco de Laranja'
    click_on 'Salvar Cardápio'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Café da Manhã'
    expect(page).to have_content 'Suco de Laranja'
    expect(page).not_to have_content 'Lasanha'
    expect(page).not_to have_content 'Macarronada'
    expect(page).not_to have_content 'Limonada'
  end
  
end
