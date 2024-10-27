require 'rails_helper'

describe 'usuário visualiza bebidas cadastradas' do
  
  it 'pela página do estabelecimento' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    beverage = Item.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    within '#Beverages' do
      expect(page).to have_content 'Cerveja'
      expect(page).to have_content 'Bebida alcoólica mais comum do Brasil'
      expect(page).to have_content '140'
      expect(page).to have_content 'Alcoólica'
    end  
  end

  it 'bebida não alcoólica' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    beverage = Item.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    within '#Beverages' do
      expect(page).to have_content 'Cerveja'
      expect(page).to have_content 'Bebida alcoólica mais comum do Brasil'
      expect(page).to have_content '140'
      expect(page).not_to have_content 'Alcoólica'
    end  
  end

  it 'e vê vários pratos diferentes' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    beverage1 = Item.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)
    beverage2 = Item.create!(name: 'Suco', description: 'O corpo da fruta', calories: '100', item_type: 'beverage', establishment: establishment, alcoholic: false)
    beverage3 = Item.create!(name: 'Vodka', description: 'Um suco diferente', calories: '200', item_type: 'beverage', establishment: establishment, alcoholic: true)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    within '#Beverages' do
      expect(page).to have_content 'Cerveja'
      expect(page).to have_content 'Suco'  
      expect(page).to have_content 'Vodka'  
      expect(page).to have_content 'Bebida alcoólica mais comum do Brasil'
      expect(page).to have_content 'O corpo da fruta'
      expect(page).to have_content 'Um suco diferente'
    end
  end
  
  it 'e vê mensagem não há bebidas cadastradas' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')

    # Act
    login_as user
    visit establishment_path(establishment)

    # Assert
    expect(page).to have_content 'Nenhuma bebida cadastrada encontrada'
  end

  it 'e não vê pratos' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)
    beverage = Item.create!(name: 'Limonada', description: 'O corpo do limão', calories: '10', item_type: 'beverage', establishment: establishment)
    
    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    within '#Beverages' do
      expect(page).not_to have_content 'Lasanha'
      expect(page).not_to have_content 'Alma do macarrão'  
      expect(page).to have_content 'Limonada'
      expect(page).to have_content 'O corpo do limão'
    end
  end

  it 'e não vê pratos de outros estabelecimentos' do
    # Arrange
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user1, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", user: user2, cnpj: CNPJ.generate, 
                                          email: 'teste123@email.com', phone_number: '99999043113')
    beverage1 = Item.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment1, alcoholic: true)
    beverage2 = Item.create!(name: 'Suco', description: 'O corpo da fruta', calories: '100', item_type: 'beverage', establishment: establishment2, alcoholic: false)

    # Act
    login_as user1
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    within '#Beverages' do
      expect(page).not_to have_content 'Suco'
      expect(page).not_to have_content 'O corpo da fruta'
      expect(page).not_to have_content '100 cal'
    end
  end
end
