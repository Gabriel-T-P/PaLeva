require 'rails_helper'

describe 'usuário edita pedido' do
  it 'pela página de mostrar um pedido (show)' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: 'Carlos Café', full_address: 'Rio Branco, Deodoro', 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(name: 'Teste01', email: 'teste123@email.com', cpf: '05513333325', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as user
    visit order_path(order)

    expect(page).to have_link 'Editar'
  end
  
  it 'pela página que lista todos os pedidos (index)' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: 'Carlos Café', full_address: 'Rio Branco, Deodoro', 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(name: 'Teste01', email: 'teste123@email.com', cpf: '05513333325', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as user
    visit orders_path

    expect(page).to have_link 'Editar'
  end
  
  it 'e vai para página de edição' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: 'Carlos Café', full_address: 'Rio Branco, Deodoro', 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(name: 'Teste01', email: 'teste123@email.com', cpf: '05513333325', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as user
    visit edit_order_path(order)

    expect(page).to have_content 'Editar Pedido'
    expect(page).to have_field 'Nome'  
    expect(page).to have_field 'E-mail'  
    expect(page).to have_field 'CPF' 
    expect(page).to have_field 'Número de Telefone'
    expect(page).to have_button 'Salvar Pedido'
    expect(page).to have_link 'Cancelar'
  end

  it 'e cancela' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: 'Carlos Café', full_address: 'Rio Branco, Deodoro', 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(name: 'Teste01', email: 'teste123@email.com', cpf: '05513333325', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as user
    visit edit_order_path(order)
    click_on 'Cancelar'

    expect(current_path).to eq root_path  
  end
  
end
