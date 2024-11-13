require 'rails_helper'

describe 'usuário vê todas as informações atuais do carrinho de pedidos' do
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as user
    visit root_path
    click_on 'Sair'

    within 'nav' do
      expect(page).not_to have_content 'Pão de Queijo, Pequeno'  
      expect(page).not_to have_content 'R$ 1,50 x 1'
    end
  end

  it 'e vê total do carrinho' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)

    login_as user
    3.times do
      visit establishment_item_portion_path(establishment, dish, portion)
      click_on 'Adicionar'
    end
    visit root_path

    within 'nav' do
      expect(page).to have_content 'Pão de Queijo, Pequeno'  
      expect(page).to have_content 'R$ 1,50 x 3'
      expect(page).to have_content 'Total:'
      expect(page).to have_content 'R$ 4,50'
    end
  end
  
  it 'e não tem itens no carrinho para calcular total' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)

    login_as user
    visit root_path

    within 'nav' do
      expect(page).to have_content 'Nenhum item adicionado'
    end
  end
  

  it 'pela página inicial' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    click_on 'Adicionar'
    visit root_path

    within 'nav' do
      expect(page).to have_content 'Pão de Queijo, Pequeno'  
      expect(page).to have_content 'R$ 1,50 x 1'
    end
  end
  
  it 'pela página de estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    click_on 'Adicionar'
    visit establishment_path(establishment)

    within 'nav' do
      expect(page).to have_content 'Pão de Queijo, Pequeno'  
      expect(page).to have_content 'R$ 1,50 x 1'
    end
  end
  
  it 'pela página do prato' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    click_on 'Adicionar'
    visit establishment_item_path(establishment, dish)

    within 'nav' do
      expect(page).to have_content 'Pão de Queijo, Pequeno'  
      expect(page).to have_content 'R$ 1,50 x 1'
    end
  end

  it 'pela página da bebida' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                establishment: establishment, alcoholic: false)
    portion = Portion.create!(name: '300 ml', description: 'Suco de Laranja em um copo de vidro de 300 ml', price: 8.00, item: beverage)
    order = Order.create!(email: 'teste123@email.com', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as user
    visit establishment_beverage_portion_path(establishment, beverage, portion)
    click_on 'Adicionar'
    visit establishment_beverage_path(establishment, beverage)

    within 'nav' do
      expect(page).to have_content 'Suco de Laranja, 300 ml'  
      expect(page).to have_content 'R$ 8,00 x 1'
    end
  end

  it 'pela página da porção' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    click_on 'Adicionar'
    visit establishment_item_portion_path(establishment, dish, portion)

    within 'nav' do
      expect(page).to have_content 'Pão de Queijo, Pequeno'  
      expect(page).to have_content 'R$ 1,50 x 1'
    end
  end

  it 'pela página de busca de itens' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    click_on 'Adicionar'
    visit establishment_items_path(establishment)

    within 'nav' do
      expect(page).to have_content 'Pão de Queijo, Pequeno'  
      expect(page).to have_content 'R$ 1,50 x 1'
    end
  end
end
