require 'rails_helper'

describe 'visitante busca por um pedido' do
  it 'pela tela inicial' do
    visit root_path

    expect(page).to have_button 'Buscar Pedido'
    expect(page).to have_field 'code'  
  end
  
  it 'com sucesso' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: 'Carlos Café', full_address: 'Rio Branco, Deodoro', 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    allow(SecureRandom).to receive(:alphanumeric).and_return('AAAA1111')
    order = Order.create!(email: 'teste123@email.com', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    visit root_path
    fill_in 'code',	with: 'AAAA1111'
    click_on 'Buscar Pedido'

    expect(current_path).to eq display_order_path
    expect(page).to have_content "Pedido: #{order.code}"
    expect(page).to have_content 'Informações do Estabelecimento'
    expect(page).to have_content 'Carlos Café'
    expect(page).to have_content 'Rio Branco, Deodoro' 
    expect(page).to have_content '99999043113'
    expect(page).to have_content 'carlosjonas@email.com'
    expect(page).to have_content 'Pão de Queijo'  
    expect(page).to have_content 'Pequeno'
    expect(page).to have_content 'R$ 1,50 x 3'
    expect(page).to have_content 'Status do Pedido'
    expect(page).to have_content 'Cancelado'
    expect(page).to have_content 'Esperando confirmação'
    expect(page).to have_content 'Em preparo'
    expect(page).to have_content 'Pronto'
    expect(page).to have_content 'Entregue'
  end
  
  it 'e não encontra pedido' do

    visit root_path
    fill_in 'code',	with: 'AAAA1111'
    click_on 'Buscar Pedido'
    
    expect(current_path).to eq root_path
    expect(page).to have_content 'Pedido não encontrado'
  end
  
  it 'entra na página de busca do pedido e faz login' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: 'Carlos Café', full_address: 'Rio Branco, Deodoro', 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    allow(SecureRandom).to receive(:alphanumeric).and_return('AAAA1111')
    order = Order.create!(email: 'teste123@email.com', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    visit root_path
    fill_in 'code',	with: 'AAAA1111'
    click_on 'Buscar Pedido'
    click_on 'Entrar'
    fill_in 'E-mail',	with: 'carlosjonas@email.com'
    fill_in 'Senha',	with: '1234567891011'
    click_on 'Login'
    
    expect(current_path).to eq root_path  
  end
  
end
