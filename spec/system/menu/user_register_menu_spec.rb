require 'rails_helper'

describe 'usuário cadastra cardápio' do
  it 'pela navegação' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    
    login_as user
    visit root_path
    within 'nav' do
      click_on 'Cadastros'
      click_on 'Cardápios'
    end

    expect(page).to have_content 'Criar Cardápio'
    expect(page).to have_field 'Nome'
    expect(page).to have_content 'Pratos para o cardápio'
    expect(page).to have_content 'Bebidas para o cardápio'
    expect(page).to have_field 'Data de Início'
    expect(page).to have_field 'Data de Fim'
    expect(page).to have_button 'Salvar Cardápio'  
  end
  
  it 'e usuário não logado não vê botão cadastros de cardápios' do
    visit root_path

    within 'nav' do
      expect(page).not_to have_button 'Cadastros'  
    end
  end
  
  it 'e não admin não vê botão de cadastro de cardápios' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    employee = Employee.create!(first_name: 'Jan', last_name: 'Jonas', cpf: CPF.generate, email: 'juanjonas@email.com', password: '1234567891011', establishment: establishment)
    
    visit root_path

    expect(page).not_to have_button 'Cadastros'
  end

  it 'e usuário não logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    
    visit new_menu_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'  
  end
  
  it 'e não admin não acessa a página' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    employee = Employee.create!(first_name: 'Jan', last_name: 'Jonas', cpf: CPF.generate, email: 'juanjonas@email.com', password: '1234567891011', establishment: establishment)
    
    login_as employee
    visit new_menu_path(establishment)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'  
  end

  it 'e cancela' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    login_as user
    visit new_menu_path
    click_on 'Cancelar'

    expect(current_path).to eq root_path
  end

  it 'e esperá ver pratos e bebidas para cadastro' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish1 = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
    dish2 = Item.create!(name: 'Macarronada', description: 'Carne moída, macarrão e molho picante', calories: '320', item_type: 'dish', establishment: establishment)
    beverage1 = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                            establishment: establishment, alcoholic: false)
    beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                            establishment: establishment, alcoholic: false)

    login_as user
    visit new_menu_path

    expect(page).to have_field 'Lasanha'  
    expect(page).to have_field 'Macarronada'  
    expect(page).to have_field 'Limonada'
    expect(page).to have_field 'Suco de Laranja'
  end
  
  it 'e so vê pratos e bebidas do estabelecimento para o cadastro do menu' do
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: 'Teste Lunch', full_address: "Av testes, 123", 
                                            cnpj: CNPJ.generate, email: 'teste123546@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
    dish1 = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment1)
    dish2 = Item.create!(name: 'Macarronada', description: 'Carne moída, macarrão e molho picante', calories: '320', item_type: 'dish', establishment: establishment2)
    beverage1 = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                            establishment: establishment1, alcoholic: false)
    beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                            establishment: establishment2, alcoholic: false)
    
    login_as user1
    visit new_menu_path

    expect(page).to have_field 'Lasanha'  
    expect(page).not_to have_field 'Macarronada'
    expect(page).to have_field 'Limonada'
    expect(page).not_to have_field 'Suco de Laranja'
  end

  it 'com sucesso' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish1 = Item.create!(name: 'Pão de Queijo', description: 'Polvilho, queijo', calories: '140', item_type: 'dish', establishment: establishment)
    beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)

    login_as user
    visit new_menu_path
    fill_in 'Nome',	with: 'Café da Manhã'
    fill_in 'Data de Início', with: 1.day.ago.to_date
    fill_in 'Data de Fim', with: 2.weeks.from_now
    check 'Suco de Laranja'
    check 'Pão de Queijo'
    click_on 'Salvar Cardápio'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Cardápio cadastrado com sucesso' 
    expect(page).to have_content 'Café da Manhã'
    expect(page).to have_content "Disponível entre os dias: #{I18n.l(1.day.ago.to_date)} até #{I18n.l(2.weeks.from_now.to_date)}"
    expect(page).to have_content 'Suco de Laranja'
    expect(page).to have_content 'Pão de Queijo'
  end
  
  it 'e não vê div das datas caso uma data não seja cadastrada' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish1 = Item.create!(name: 'Pão de Queijo', description: 'Polvilho, queijo', calories: '140', item_type: 'dish', establishment: establishment)
    beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)

    login_as user
    visit new_menu_path
    fill_in 'Nome',	with: 'Café da Manhã'
    check 'Suco de Laranja'
    check 'Pão de Queijo'
    click_on 'Salvar Cardápio'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Cardápio cadastrado com sucesso' 
    expect(page).to have_content 'Café da Manhã'
    expect(page).not_to have_content 'Disponível entre os dias'
    expect(page).to have_content 'Suco de Laranja'
    expect(page).to have_content 'Pão de Queijo'
  end

  it 'e não vê itens que não foram marcados' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish1 = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
    dish2 = Item.create!(name: 'Macarronada', description: 'Carne moída, macarrão e molho picante', calories: '320', item_type: 'dish', establishment: establishment)
    beverage1 = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
    beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)

    login_as user
    visit new_menu_path
    fill_in 'Nome',	with: 'Café da Manhã'
    check 'Suco de Laranja'
    click_on 'Salvar Cardápio'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Café da Manhã'
    expect(page).to have_content 'Suco de Laranja'
    expect(page).not_to have_content 'Lasanha'
    expect(page).not_to have_content 'Macarronada'
    expect(page).not_to have_content 'Limonada'
  end
  
  it 'e outros estabelecimentos podem cadastrar com um mesmo nome de cardápio' do
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: 'Teste Lunch', full_address: "Av testes, 123", 
                                            cnpj: CNPJ.generate, email: 'teste123546@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
    
    login_as user1
    visit new_menu_path
    fill_in 'Nome',	with: 'Almoço'
    click_on 'Salvar Cardápio'
    login_as user2
    visit new_menu_path
    fill_in 'Nome',	with: 'Almoço'
    click_on 'Salvar Cardápio'
    
    expect(page).to have_content 'Cardápio cadastrado com sucesso'
    expect(page).to have_content 'Almoço'
  end
  
  it 'e um mesmo prato ou bebida pode ser adicionado em vários cardápios' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish1 = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado', calories: '100', item_type: 'dish', establishment: establishment)
    dish2 = Item.create!(name: 'Macarronada', description: 'Carne moída, macarrão e molho picante', calories: '320', item_type: 'dish', establishment: establishment)
    beverage1 = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
    beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)

    login_as user
    visit new_menu_path
    fill_in 'Nome',	with: 'Café da Manhã'
    check 'Suco de Laranja'
    check 'Pão de Queijo'
    click_on 'Salvar Cardápio'
    visit new_menu_path
    fill_in 'Nome',	with: 'Café da Manhã 2, ele Denovo'
    check 'Suco de Laranja'
    check 'Pão de Queijo'
    click_on 'Salvar Cardápio'

    expect(page).to have_content 'Cardápio cadastrado com sucesso' 
    expect(page).to have_content 'Café da Manhã'
    expect(page).to have_content 'Café da Manhã 2, ele Denovo'
  end

  it 'e vê mensagens de erros' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    login_as user
    visit new_menu_path
    fill_in 'Nome',	with: ''
    fill_in 'Data de Início', with: Date.today
    click_on 'Salvar Cardápio'

    expect(page).to have_content 'Nome não pode ficar em branco'  
    expect(page).to have_content 'Data de Fim não pode ficar em branco'
  end

  it 'e vê mensagem de erro da data de ínicio depois da data de fim' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish1 = Item.create!(name: 'Pão de Queijo', description: 'Polvilho, queijo', calories: '140', item_type: 'dish', establishment: establishment)
    beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)

    login_as user
    visit new_menu_path
    fill_in 'Nome',	with: 'Café da Manhã'
    fill_in 'Data de Início', with: Date.today
    fill_in 'Data de Fim', with: 2.weeks.ago
    check 'Suco de Laranja'
    check 'Pão de Queijo'
    click_on 'Salvar Cardápio'

    expect(page).to have_content 'Falha ao cadastrar o cardápio'  
    expect(page).to have_content 'Data de Início deve ser antes da Data de Fim'  
  end

  it 'e vê mensagem de erro do Nome já em uso dentro do estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    Menu.create!(name: 'Almoço', establishment: establishment)

    login_as user
    visit new_menu_path
    fill_in 'Nome',	with: 'Almoço'
    click_on 'Salvar Cardápio'

    expect(page).to have_content 'Nome já está em uso'
  end
end
