require 'rails_helper'

describe 'usuário vê cardápio' do
  it 'pela tela inicial do aplicativo' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado', calories: '100', item_type: 'dish', establishment: establishment)
    beverage = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)
    menu.items<<[dish, beverage]

    login_as user
    visit root_path

    expect(page).to have_content 'Café da Manhã'
    expect(page).to have_content 'Pão de Queijo'
    expect(page).to have_content 'Suco de Laranja'
  end
  
  it 'e usuário não está logado' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado', calories: '100', item_type: 'dish', establishment: establishment)
    beverage = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)
    menu.items<<[dish, beverage]

    visit root_path

    expect(page).to have_content 'Para acessar suas informações, por favor faça login'
    expect(page).not_to have_content 'Café da Manhã'
    expect(page).not_to have_content 'Pão de Queijo'
    expect(page).not_to have_content 'Suco de Laranja'
  end
  

  it 'e vê as porções dos pratos e bebidas com os preços' do
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

    login_as user
    visit root_path

    expect(page).to have_content 'Pão de Queijo'  
    expect(page).to have_content 'Pequeno - R$ 1,50'  
    expect(page).to have_content 'Grande - R$ 5,99'
    expect(page).to have_content 'Suco de Laranja'
    expect(page).to have_content '300 ml - R$ 8,00'  
    expect(page).to have_content '750 ml - R$ 18,00'
  end
  
  it 'e vê somente os cardápios do estabelecimento' do
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: 'Rio Branco, Deodoro', user: user1, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: 'Teste Lunch', full_address: 'Av testes, 123', user: user2, 
                                            cnpj: CNPJ.generate, email: 'teste123546@email.com', phone_number: '99999043113')
    Menu.create!(name: 'Almoço', establishment: establishment1)
    Menu.create!(name: 'Jantar', establishment: establishment2)

    login_as user1
    visit root_path

    expect(page).to have_content 'Almoço'  
    expect(page).not_to have_content 'Jantar'
  end
  
  it 'e vê vários cardápios com vários pratos e bebidas' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish1 = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado', calories: '100', item_type: 'dish', establishment: establishment)
    dish2 = Item.create!(name: 'Macarronada', description: 'Carne moída, macarrão e molho picante', calories: '320', item_type: 'dish', establishment: establishment)
    beverage1 = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
    beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
    menu = Menu.create!(name: 'Café da Manhã', establishment: establishment)
    menu.items<<[dish1, beverage2]
    other_menu = Menu.create!(name: 'Lanche', establishment: establishment)
    other_menu.items<<[dish2, beverage1]

    login_as user
    visit root_path

    expect(page).to have_content 'Café da Manhã'
    expect(page).to have_content 'Pão de Queijo'  
    expect(page).to have_content 'Suco de Laranja'  
    expect(page).to have_content 'Lanche'  
    expect(page).to have_content 'Macarronada'  
    expect(page).to have_content 'Limonada'
  end

  it "description" do
    
  end
  
end
