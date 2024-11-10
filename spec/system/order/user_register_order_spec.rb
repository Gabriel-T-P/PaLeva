require 'rails_helper'

describe 'usuário registra pedido' do
  it 'pelo carrinho de pedidos' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 3 
    click_on 'Adicionar'
    within 'nav' do
      click_on 'Ver Pedido'
    end

    expect(page).to have_content 'Cadastro do Pedido'
    expect(page).to have_content 'Pão de Queijo'
    expect(page).to have_content 'Pequeno'     
    expect(page).to have_content 'R$ 1,50 x 3'
    expect(page).to have_field 'Nome do Cliente'
    expect(page).to have_field 'E-mail'    
    expect(page).to have_field 'CPF'    
    expect(page).to have_field 'Número de Telefone'
    expect(page).to have_button 'Salvar Pedido'
  end
  
  it 'e não está logado' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    visit new_order_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end
  
  it 'com sucesso' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 3
    click_on 'Adicionar'
    within 'nav' do
      click_on 'Ver Pedido'
    end
    fill_in 'Nome do Cliente',	with: 'Teste' 
    fill_in 'E-mail',	with: 'teste123@email.com' 
    fill_in 'CPF',	with: CPF.generate
    fill_in 'Número de Telefone',	with: '99999043113'
    click_on 'Salvar Pedido' 

    expect(page).to have_content 'Pedido registrado com sucesso'
    expect(page).to have_content 'Informações do Pedido'
    expect(page).to have_content 'Pão de Queijo'  
    expect(page).to have_content 'Pequeno'
    expect(page).to have_content 'R$ 1,50 x 3'
  end
  
end
