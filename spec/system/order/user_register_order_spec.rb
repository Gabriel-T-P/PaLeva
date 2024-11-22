require 'rails_helper'

describe 'usuário registra pedido' do
  it 'pelo carrinho de pedidos' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]

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
    expect(page).to have_content 'Total'
    expect(page).to have_content 'R$ 4,50'
    expect(page).to have_field 'Nome do Cliente'
    expect(page).to have_field 'E-mail'    
    expect(page).to have_field 'CPF'    
    expect(page).to have_field 'Número de Telefone'
    expect(page).to have_button 'Salvar Pedido'
  end
  
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(email: 'teste123@email.com', user: user)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    visit new_order_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end
  
  it 'com sucesso' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 3
    fill_in 'Observação',	with: 'sometext' 
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
    expect(page).to have_content 'sometext'
    expect(page).to have_content 'R$ 1,50 x 3'
    expect(page).to have_content 'Total:'  
    expect(page).to have_content 'R$ 4,50'
  end
  
  it 'e carrinho fica vazio após registro do pedido' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]

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

    within 'nav' do
      expect(page).to have_content 'Nenhum item adicionado'  
      expect(page).not_to have_content 'Pão de Queijo'  
      expect(page).not_to have_content 'Pequeno'
      expect(page).not_to have_content 'R$ 1,50 x 3'
    end
  end
  
  it 'e vê mensagens de erro' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 3
    click_on 'Adicionar'
    within 'nav' do
      click_on 'Ver Pedido'
    end
    fill_in 'Nome do Cliente',	with: '' 
    fill_in 'E-mail',	with: '' 
    fill_in 'CPF',	with: ''
    fill_in 'Número de Telefone',	with: ''
    click_on 'Salvar Pedido'

    expect(page).to have_content 'Número de Telefone não pode ficar em branco'  
    expect(page).to have_content 'E-mail não pode ficar em branco'
  end
  
  it 'e um código alfanumérico de 8 caracteres aleatório é gerado para aquele pedido' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCD1234')

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

    expect(page).to have_content 'ABCD1234'
  end
  
  it 'e recebe status Aguardando confirmação da cozinha após registro' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    menu.items << [dish]
    allow(SecureRandom).to receive(:alphanumeric).and_return('AAAA1111')

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 3
    click_on 'Adicionar'
    within 'nav' do
      click_on 'Ver Pedido'
    end
    fill_in 'Nome do Cliente',	with: 'Teste'
    fill_in 'E-mail',	with: 'teste123@email.com'
    fill_in 'CPF',	with: '055.133.333-25'
    fill_in 'Número de Telefone',	with: '99999043113'
    click_on 'Salvar Pedido'

    expect(page).to have_content 'AAAA1111'
    expect(page).to have_content 'Teste'
    expect(page).to have_content 'teste123@email.com'
    expect(page).to have_content '055.133.333-25'
    expect(page).to have_content '99999043113'
    expect(page).to have_content 'Aguardando confirmação da cozinha'
  end
  
  it 'e pedido possui desconto válido' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    invalid_promotion = Promotion.create!(name: 'Mês do Pão de Queijo', percentage: 0.10, use_limit: 20, start_date: 1.week.from_now.to_date, end_date: 1.month.from_now.to_date, portions: [portion])
    promotion = Promotion.create!(name: 'Semana do Pão de Queijo', percentage: 0.20, use_limit: 20, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])
    promotion2 = Promotion.create!(name: 'Outra Semana do Pão de Queijo', percentage: 0.05, use_limit: 20, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 3
    click_on 'Adicionar'
    within 'nav' do
      click_on 'Ver Pedido'
    end

    expect(page).to have_content 'Descontos disponíveis'
    expect(page).to have_content 'Preço Final'
    expect(page).to have_content 'R$ 3,38'
    expect(page).to have_content 'Semana do Pão de Queijo'
    expect(page).to have_content '20.0%'
    expect(page).to have_content 'Outra Semana do Pão de Queijo'
    expect(page).to have_content '5.0%'
    expect(page).not_to have_content 'Mês do Pão de Queijo'
    expect(page).not_to have_content '10.0%'  
  end
  
  it 'e não possui descontos válidos' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 3
    fill_in 'Observação',	with: 'sometext' 
    click_on 'Adicionar'
    within 'nav' do
      click_on 'Ver Pedido'
    end

    expect(page).not_to have_content 'Descontos disponíveis'
    expect(page).to have_content 'sem descontos disponíveis'
    expect(page).to have_content 'Preço Final'  
    expect(page).to have_content 'R$ 4,50'
  end

  it 'e o desconto existente estorou o limite de uso válido' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    invalid_promotion = Promotion.create!(name: 'Mês do Pão de Queijo', percentage: 0.10, use_limit: 0, start_date: 1.week.ago.to_date, end_date: 1.month.from_now.to_date, portions: [portion])
    promotion = Promotion.create!(name: 'Semana do Pão de Queijo', percentage: 0.20, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 3
    click_on 'Adicionar'
    within 'nav' do
      click_on 'Ver Pedido'
    end

    expect(page).to have_content 'R$ 3,60'
    expect(page).to have_content 'Semana do Pão de Queijo'
    expect(page).to have_content '20.0%'
    expect(page).not_to have_content 'Mês do Pão de Queijo'
    expect(page).not_to have_content '10.0%'  
  end
  
end
