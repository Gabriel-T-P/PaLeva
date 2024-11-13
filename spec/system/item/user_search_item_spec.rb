require 'rails_helper'

describe 'usuário procura por bebidas e pratos' do
  it 'pelá página inicial do app' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Buscar por Pratos e Bebidas'

    # Assert
    expect(current_path).to eq establishment_items_path(establishment)
    expect(page).to have_content 'Pratos e Bebidas'
    expect(page).to have_field 'Buscar por nome ou descrição'
    expect(page).to have_button 'Buscar'  
  end
  
  it 'e deve estar autenticado para aparecer botão' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Buscar por Pratos e Bebidas' 
  end

  it 'e deve ser admin para aparecer o botão' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    employee = Employee.create!(first_name: 'Juan', last_name: 'Jonas', cpf: CPF.generate, email: 'juanjonas@email.com', password: '1234567891011', establishment: establishment)

    login_as employee
    visit root_path

    expect(page).not_to have_link 'Buscar por Pratos e Bebidas' 
  end

  it 'e deve estar autenticado' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    visit establishment_items_path(establishment)

    # Assert
    expect(current_path).to eq new_user_session_path 
  end

  it 'e deve ser admin' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    employee = Employee.create!(first_name: 'Juan', last_name: 'Jonas', cpf: CPF.generate, email: 'juanjonas@email.com', password: '1234567891011', establishment: establishment)

    login_as employee
    visit establishment_items_path(establishment)
  end

  it 'com sucesso e mostra todos os cadastros' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Buscar por Pratos e Bebidas'
    fill_in 'Buscar por nome ou descrição',	with: ''
    click_on 'Buscar'
    
    # Assert
    expect(current_path).to eq establishment_items_path(establishment)
    expect(page).to have_content 'Cerveja'
    expect(page).to have_content 'Bebida alcoólica mais comum do Brasil'
    expect(page).to have_content '140 cal'
    expect(page).to have_content 'Alcoólica'
    expect(page).to have_content 'Lasanha'
    expect(page).to have_content 'Alma do macarrão'
    expect(page).to have_content '400 cal'
  end
  
  it 'com sucesso pelo nome' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Buscar por Pratos e Bebidas'
    fill_in 'Buscar por nome ou descrição',	with: 'Cerveja'
    click_on 'Buscar'
    
    # Assert
    expect(current_path).to eq establishment_items_path(establishment)
    expect(page).to have_content 'Cerveja'
    expect(page).to have_content 'Bebida alcoólica mais comum do Brasil'
    expect(page).to have_content '140 cal'
    expect(page).to have_content 'Alcoólica'
    expect(page).not_to have_content 'Lasanha'
    expect(page).not_to have_content 'Alma do macarrão'
    expect(page).not_to have_content '400 cal'
  end
  
  it 'com sucesso pela descrição' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Limonada', description: 'Bebida mais refrescante', calories: '50', item_type: 'beverage', establishment: establishment, alcoholic: false)
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Buscar por Pratos e Bebidas'
    fill_in 'Buscar por nome ou descrição',	with: 'Bebida mais refrescante'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content 'Limonada'
    expect(page).to have_content 'Bebida mais refrescante'
    expect(page).to have_content '50 cal'
    expect(page).not_to have_content 'Alcoólica'  
    expect(page).not_to have_content 'Lasanha'
    expect(page).not_to have_content 'Alma do macarrão'
    expect(page).not_to have_content '400 cal'
  end
  
  it 'e não existem item com os dados pesquisados' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Limonada', description: 'Bebida mais refrescante', calories: '50', item_type: 'beverage', establishment: establishment, alcoholic: false)
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Buscar por Pratos e Bebidas'
    fill_in 'Buscar por nome ou descrição',	with: 'Suco de Laranja'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content 'Nenhum item cadastrado com a informação pedida'
  end
  
  it 'e não pode acessar a página diretamente sem estar autenticado' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    visit establishment_items_path(establishment)

    # Assert
    expect(current_path).to eq new_user_session_path  
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'e acessa os detalhes da bebida pela busca' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Limonada', description: 'Bebida mais refrescante', calories: '50', item_type: 'beverage', establishment: establishment, alcoholic: false)

    # Act
    login_as user
    visit root_path
    click_on 'Buscar por Pratos e Bebidas'
    fill_in 'Buscar por nome ou descrição',	with: 'Limonada'
    click_on 'Buscar'
    click_on 'Limonada'

    # Assert
    expect(current_path).to eq establishment_beverage_path(establishment, beverage)
    expect(page).to have_content 'Nenhuma imagem cadastrada'
    expect(page).to have_content 'Limonada' 
    expect(page).to have_content 'Bebida mais refrescante' 
    expect(page).to have_content '50 cal' 
    expect(page).not_to have_content 'Alcoólica'
    expect(page).to have_link 'Editar Bebida'
    expect(page).to have_button 'Deletar Bebida'
  end
  
  it 'e botão de editar da bebida leva para a tela de edição' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Limonada', description: 'Bebida mais refrescante', calories: '50', item_type: 'beverage', establishment: establishment, alcoholic: false)

    # Act
    login_as user
    visit root_path
    click_on 'Buscar por Pratos e Bebidas'
    fill_in 'Buscar por nome ou descrição',	with: 'Limonada'
    click_on 'Buscar'
    click_on 'Limonada'
    click_on 'Editar Bebida'

    # Assert
    expect(current_path).to eq edit_establishment_beverage_path(establishment, beverage)
  end
  
  it 'e acessa os detalhes do prato pela busca' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Lasanha', description: 'Muito sabarosa', calories: '350', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Buscar por Pratos e Bebidas'
    fill_in 'Buscar por nome ou descrição',	with: 'Lasanha'
    click_on 'Buscar'
    click_on 'Lasanha'

    # Assert
    expect(current_path).to eq establishment_item_path(establishment, dish)
    expect(page).to have_content 'Nenhuma imagem cadastrada'
    expect(page).to have_content 'Lasanha' 
    expect(page).to have_content 'Muito sabarosa' 
    expect(page).to have_content '350 cal' 
    expect(page).to have_link 'Editar Prato'
    expect(page).to have_button 'Deletar Prato'
  end
  
  it 'e botão de editar do prato leva para a tela de edição' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Lasanha', description: 'Muito sabarosa', calories: '350', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Buscar por Pratos e Bebidas'
    fill_in 'Buscar por nome ou descrição',	with: 'Lasanha'
    click_on 'Buscar'
    click_on 'Lasanha'
    click_on 'Editar Prato'

    # Assert
    expect(current_path).to eq edit_establishment_item_path(establishment, dish)
  end

  it 'e não vê pratos e bebidas de outros estabelecimentos sem fazer pesquisa' do
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: 'Teste Lunch', full_address: "Av testes, 123", 
                                            cnpj: CNPJ.generate, email: 'teste123546@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
    beverage = Beverage.create!(name: 'Limonada', description: 'Bebida mais refrescante', calories: '50', item_type: 'beverage', establishment: establishment1, alcoholic: false)
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment2)

    login_as user1
    visit establishment_items_path(establishment1)

    expect(page).to have_content 'Limonada'
    expect(page).not_to have_content 'Lasanha'
  end
  
  it 'e não vê pratos ou bebidas de outros estabelecimentos ao fazer a pesquisa' do
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: 'Teste Lunch', full_address: "Av testes, 123", 
                                            cnpj: CNPJ.generate, email: 'teste123546@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment2)

    login_as user1
    visit establishment_items_path(establishment1)
    fill_in 'Buscar por nome ou descrição',	with: 'Lasanha'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhum item cadastrado com a informação pedida'
    expect(page).not_to have_content 'Lasanha'
  end
  
end
