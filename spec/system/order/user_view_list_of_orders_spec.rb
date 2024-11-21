require 'rails_helper'

describe 'usuário vê lista de pedidos' do
  it 'pela user sidebar' do
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
    visit root_path
    within '#UserSidebar' do
      click_on 'Pedido'
    end

    expect(current_path).to eq orders_path
    expect(page).to have_content 'Teste01'  
    expect(page).to have_content 'teste123@email.com'  
    expect(page).to have_content '05513333325'  
    expect(page).to have_content 'Carlos Jonas'
  end
  
  it 'e não está logado' do

    visit orders_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'    
  end
  
  it 'e não admin somente vê pedidos em que é dono' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: 'Carlos Café', full_address: 'Rio Branco, Deodoro', 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    employee = Employee.create!(first_name: 'Rein', last_name: 'Jonas', cpf: CPF.generate, email: 'reinJonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(name: 'Teste01', email: 'teste123@email.com', cpf: '05829579073', user: user)
    order = Order.create!(name: 'Teste02', email: 'teste321@email.com', cpf: '01234133032', user: employee)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as employee
    visit orders_path

    expect(page).to have_content 'Teste02'  
    expect(page).to have_content 'teste321@email.com'  
    expect(page).to have_content '01234133032'  
    expect(page).not_to have_content 'Teste01'  
    expect(page).not_to have_content 'teste123'  
    expect(page).not_to have_content '05829579073'  
  end
  
end
