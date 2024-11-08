require 'rails_helper'

describe 'usuário registra item a um pedido' do
  it 'pelos cardápios de um prato na página inicial' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)
    menu.items<<[dish]

    login_as user
    visit root_path
    within '#Menus' do
      click_on 'Pequeno - R$ 1,50'
    end

    expect(current_path).to eq establishment_item_portion_path(establishment, dish, portion)
    expect(page).to have_field 'Quantidade'
    expect(page).to have_field 'Observação'
    expect(page).to have_button 'Adicionar'
  end

  it 'pelos cardápios de uma bebida na página inicial' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    beverage = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                establishment: establishment, alcoholic: false)
    portion = Portion.create!(name: '300 ml', description: 'Suco de Laranja em um copo de vidro de 300 ml', price: 8.00, item: beverage)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)
    menu.items<<[beverage]

    login_as user
    visit root_path
    within '#Menus' do
      click_on '300 ml - R$ 8,00'
    end

    expect(current_path).to eq establishment_beverage_portion_path(establishment, beverage, portion)
    expect(page).to have_field 'Quantidade'
    expect(page).to have_field 'Observação'
    expect(page).to have_button 'Adicionar'
  end
  
  it 'com sucesso' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)

    fill_in 'Quantidade',	with: 1 
    fill_in 'Observação',	with: ''
    click_on 'Adicionar'
    
    expect(current_path).to eq root_path
    expect(page).to have_content 'Pão de Queijo, Pequeno - R$ 1,50'  
  end
  

  it '' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    Portion.create!(name: 'Grande', description: 'Uma unidade grande de pão de queijo', price: 5.99, item: dish)
    beverage = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
    Portion.create!(name: '300 ml', description: 'Suco de Laranja em um copo de vidro de 300 ml', price: 8.00, item: beverage)
    Portion.create!(name: '750 ml', description: 'Suco de Laranja em um copo de vidro de 750 ml', price: 18.00, item: beverage)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)
    menu.items<<[dish, beverage]
  end
  
end
