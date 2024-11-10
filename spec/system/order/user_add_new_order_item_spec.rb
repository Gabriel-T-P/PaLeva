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
    expect(page).to have_content 'Pão de Queijo, Pequeno'
    expect(page).to have_content 'R$ 1,50 x 1'
    expect(page).to have_link 'Ver Pedido'  
  end

  it 'e vê vários itens no carrinho' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion1 = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    portion2 = Portion.create!(name: 'Grande', description: 'Uma unidade grande de pão de queijo', price: 5.99, item: dish)
    beverage = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
    portion3 = Portion.create!(name: '300 ml', description: 'Suco de Laranja em um copo de vidro de 300 ml', price: 8.00, item: beverage)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion1)
    fill_in 'Quantidade',	with: 1
    click_on 'Adicionar'
    visit establishment_item_portion_path(establishment, dish, portion2)
    fill_in 'Quantidade',	with: 2
    click_on 'Adicionar'
    visit establishment_beverage_portion_path(establishment, beverage, portion3)
    fill_in 'Quantidade',	with: 1
    click_on 'Adicionar'

    within 'nav' do
      expect(page).to have_content 3
      expect(page).to have_content 'Pão de Queijo, Pequeno'
      expect(page).to have_content 'R$ 1,50 x 1'
      expect(page).to have_content 'Pão de Queijo, Grande'
      expect(page).to have_content 'R$ 5,99 x 2'
      expect(page).to have_content 'Suco de Laranja, 300 ml'
      expect(page).to have_content 'R$ 8,00 x 1'
    end  
  end
  
  it 'e número de itens no carrinho reflete a quantidade de itens' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion1 = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    portion2 = Portion.create!(name: 'Grande', description: 'Uma unidade grande de pão de queijo', price: 5.99, item: dish)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion1)
    fill_in 'Quantidade',	with: 3
    click_on 'Adicionar'
    visit establishment_item_portion_path(establishment, dish, portion2)
    fill_in 'Quantidade',	with: 2
    click_on 'Adicionar'

    within 'nav' do
      expect(page).to have_content 5
    end
  end

  it 'e não vê campos de adicionar item ao pedido se porção indisponível' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    portion.update(active: false)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)

    expect(page).not_to have_field 'Quantidade'
    expect(page).not_to have_field 'Observação'
    expect(page).not_to have_button 'Adicionar'
  end

  it 'e carrinho somente tem itens do pedido atual' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    portion2 = Portion.create!(name: 'Grande', description: 'Uma unidade grande de pão de queijo', price: 5.99, item: dish)
    order = Order.create!(name: 'Teste', email: 'teste123@email.com', status: 'delivered', user: user)
    PortionOrder.create!(order: order, portion: portion2, quantity: 1)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 3
    click_on 'Adicionar'

    within 'nav' do
      expect(page).to have_content 'Pão de Queijo, Pequeno'
      expect(page).to have_content 'R$ 1,50 x 3'
      expect(page).not_to have_content 'Pão de Queijo, Grande'
      expect(page).not_to have_content 'R$ 5,99 x 1'
    end
  end
  
  it 'e ao falhar em salvar renderiza corretamente a página da porção' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: '1.5'
    click_on 'Adicionar'

    expect(current_path).to eq establishment_item_portion_path(establishment, dish, portion)
    expect(page).to have_content 'Quantidade não é um número inteiro' 
  end
  
  it 'e vê mensagens de erros' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: ''
    fill_in 'Observação',	with: 'abcd' 
    click_on 'Adicionar'

    expect(page).to have_content 'Quantidade não é um número'
    expect(page).to have_content 'Observação possui 6 caracteres como mínimo permitido'
  end
  
  it 'e adiciona item que já estava no carrinho' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 1
    click_on 'Adicionar'
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 2
    click_on 'Adicionar'

    expect(page).to have_content 'Item adicionado ao carrinho'
    within 'nav' do
      expect(page).to have_content 'Pão de Queijo, Pequeno'
      expect(page).to have_content 'R$ 1,50 x 3'
    end 
  end
  
end
