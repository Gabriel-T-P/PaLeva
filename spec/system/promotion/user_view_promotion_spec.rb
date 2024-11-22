require 'rails_helper'

describe ' usuário vê detalhes de uma promoção' do
  it 'e vê pedidos daquela promoção' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    promotion = Promotion.create!(name: 'Semana do Pão de Queijo', percentage: 0.20, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])
    menu = Menu.create!(name: 'teste', establishment: establishment, items: [dish])
    allow(SecureRandom).to receive(:alphanumeric).and_return('AAAA1111')
    order = Order.create!(name: 'teste', email: 'teste@email.com', user: user, promotions: [promotion])

    login_as user
    visit promotion_path(promotion)

    expect(page).to have_content 'AAAA1111'
    expect(page).to have_content 'teste'
  end
  
  it 'e pode acessar a página de detalhes daquele pedido' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    promotion = Promotion.create!(name: 'Semana do Pão de Queijo', percentage: 0.20, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])
    menu = Menu.create!(name: 'teste', establishment: establishment, items: [dish])
    allow(SecureRandom).to receive(:alphanumeric).and_return('AAAA1111')
    order = Order.create!(name: 'teste', email: 'teste@email.com', user: user, promotions: [promotion])

    login_as user
    visit promotion_path(promotion)
    click_on 'AAAA1111'

    expect(current_path).to eq order_path(order)  
  end
  
  it 'e usuário não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    promotion = Promotion.create!(name: 'Semana do Pão de Queijo', percentage: 0.20, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])

    visit promotion_path(promotion)

    expect(current_path).to eq new_user_session_path  
  end
  
  it 'e usuário não é admin' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = Employee.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    promotion = Promotion.create!(name: 'Semana do Pão de Queijo', percentage: 0.20, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])

    login_as user
    visit promotion_path(promotion)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'
  end
end
