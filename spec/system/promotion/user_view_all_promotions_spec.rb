require 'rails_helper'

describe 'usuário vê todas as promoções' do
  it 'pela user sidebar' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    promotion = Promotion.create!(name: 'Semana do Pão de Queijo', percentage: 0.20, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])
    promotion2 = Promotion.create!(name: 'Mês do Pão de Queijo', percentage: 0.10, use_limit: 20, start_date: 1.week.ago.to_date, end_date: 1.month.from_now.to_date, portions: [portion])
    promotion3 = Promotion.create!(name: 'Ano do Pão de Queijo', percentage: 0.05, start_date: 1.week.ago.to_date, end_date: 1.year.from_now.to_date, portions: [portion])
    menu = Menu.create!(name: 'teste', establishment: establishment, items: [dish])

    login_as user
    visit root_path
    within '#UserSidebar' do
      click_on 'Promoção'
    end

    expect(current_path).to eq promotions_path 
    expect(page).to have_content 'Lista de Promoções'
    expect(page).to have_content 'Semana do Pão de Queijo'
    expect(page).to have_content 'Mês do Pão de Queijo'
    expect(page).to have_content 'Ano do Pão de Queijo'
  end
  
  it 'e usuário não está logado' do
    
    visit promotions_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'    
  end
  
  it 'e não é admin' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = Employee.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    login_as user
    visit promotions_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'
  end
  
  it 'e da acesso a página de detalhes de uma promoção' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    promotion = Promotion.create!(name: 'Semana do Pão de Queijo', percentage: 0.20, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])
    menu = Menu.create!(name: 'teste', establishment: establishment, items: [dish])

    login_as user
    visit promotions_path
    click_on 'Detalhes'

    expect(current_path).to eq promotion_path(promotion)  
  end
end
