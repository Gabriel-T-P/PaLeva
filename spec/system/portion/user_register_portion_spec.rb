require 'rails_helper'

describe 'usuário cadastra porção' do
  it 'pela página do modelo do item a ser criado como bebida' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', 
                                establishment: establishment, alcoholic: true)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Beverages' do
      click_on 'Cerveja'
    end
    click_on 'Adicionar Porção'

    # Assert
    expect(page).to have_content 'Nova Porção para a Bebida Cerveja'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Preço'
  end
  
  it 'pela página do modelo do item a ser criado como prato' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Dishs' do
      click_on 'Lasanha'
    end
    click_on 'Adicionar Porção'

    # Assert
    expect(page).to have_content 'Nova Porção para o Prato Lasanha'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Preço'
  end

  it 'pela página do modelo do item a ser criado como bebida e cancela' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', 
                                establishment: establishment, alcoholic: true)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Beverages' do
      click_on 'Cerveja'
    end
    click_on 'Adicionar Porção'
    click_on 'Cancelar'

    # Assert
    expect(current_path).to eq establishment_beverage_path(establishment, beverage)
  end

  it 'pela página do modelo do item a ser criado como prato e cancela' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Dishs' do
      click_on 'Lasanha'
    end
    click_on 'Adicionar Porção'
    click_on 'Cancelar'

    # Assert
    expect(current_path).to eq establishment_item_path(establishment, dish)  
  end

  it 'com sucesso como uma bebida' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', 
                                establishment: establishment, alcoholic: true)

    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Beverages' do
      click_on 'Cerveja'
    end
    click_on 'Adicionar Porção'
    fill_in 'Nome',	with: 'Cerveja 400 ml'
    fill_in 'Descrição',	with: 'Cerveja de 400 ml em um copo de vidro, sem aperitivos'
    fill_in 'Preço',	with: '12.40'
    click_on 'Salvar Porção'

    expect(current_path).to eq establishment_beverage_path(establishment, beverage)
    expect(page).to have_content 'Porção cadastrada com sucesso'
    expect(page).to have_content 'Ativo'
    expect(page).to have_content 'Cerveja 400 ml'
    expect(page).to have_content 'Cerveja de 400 ml em um copo de vidro, sem aperitivos'
    expect(page).to have_content 'R$ 12,40'
  end
  
  it 'com sucesso como prato' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)

    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Dishs' do
      click_on 'Lasanha'
    end
    click_on 'Adicionar Porção'
    fill_in 'Nome',	with: 'Lasanha Média'
    fill_in 'Descrição',	with: 'Lasanha de carne e molho bolonhesa, server 2 pessoas' 
    fill_in 'Preço',	with: '30.99'
    click_on 'Salvar Porção' 
    
    expect(current_path).to eq establishment_item_path(establishment, dish)
    expect(page).to have_content 'Porção cadastrada com sucesso'
    expect(page).to have_content 'Ativo'  
    expect(page).to have_content 'Lasanha Média'  
    expect(page).to have_content 'Lasanha de carne e molho bolonhesa, server 2 pessoas'
    expect(page).to have_content 'R$ 30,99'
  end

  it 'e vê mensagens de erros' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)

    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Dishs' do
      click_on 'Lasanha'
    end
    click_on 'Adicionar Porção'
    fill_in 'Nome',	with: ''
    fill_in 'Descrição',	with: '' 
    fill_in 'Preço',	with: ''
    click_on 'Salvar Porção' 
    
    expect(page).to have_content 'Falha ao cadastrar a porção'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Preço não pode ficar em branco'
  end
  
end
