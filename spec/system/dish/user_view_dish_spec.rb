require 'rails_helper'

describe 'usuário visualiza pratos cadastrados' do
  
  it 'pela página do estabelecimento' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    within '#Dishs' do
      expect(page).to have_content 'Lasanha'
      expect(page).to have_content 'Alma do macarrão'  
      expect(page).to have_content '400'
    end  
  end
  
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

    visit establishment_path(establishment)

    expect(current_path).to eq new_user_session_path  
  end

  it 'e não é admin do estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
    user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)

    login_as user2
    visit establishment_item_path(establishment, dish)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'  
  end

  it 'e vê vários pratos diferentes' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish1 = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)
    dish2 = Item.create!(name: 'Macarronada', description: 'O corpo do macarrão', calories: '300', item_type: 'dish', establishment: establishment)
    dish3 = Item.create!(name: 'Pizza', description: 'O mais vendido', calories: '400', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    within '#Dishs' do
      expect(page).to have_content 'Lasanha'
      expect(page).to have_content 'Macarronada'  
      expect(page).to have_content 'Pizza'  
      expect(page).to have_content 'Alma do macarrão'
      expect(page).to have_content 'O corpo do macarrão'
      expect(page).to have_content 'O mais vendido'
    end
  end
  
  it 'e vê mensagem não há pratos cadastrados' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit establishment_path(establishment)

    # Assert
    expect(page).to have_content 'Nenhum prato cadastrado encontrado'
  end

  it 'e não vê bebidas' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish1 = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)
    dish2 = Item.create!(name: 'Limonada', description: 'O corpo do limão', calories: '10', item_type: 'beverage', establishment: establishment)
    
    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    within '#Dishs' do
      expect(page).to have_content 'Lasanha'
      expect(page).to have_content 'Alma do macarrão'  
      expect(page).not_to have_content 'Limonada'
      expect(page).not_to have_content 'O corpo do limão'
    end
  end

  it 'e não vê pratos de outros estabelecimentos' do
    # Arrange
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", cnpj: CNPJ.generate, 
                                          email: 'teste123@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
    dish1 = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment1)
    dish2 = Item.create!(name: 'Pastel', description: 'Não é de vento', calories: '100', item_type: 'dish', establishment: establishment2)

    # Act
    login_as user1
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    within '#Dishs' do
      expect(page).not_to have_content 'Pastel'
      expect(page).not_to have_content 'Não é de vento'
      expect(page).not_to have_content '10 cal'
    end
  end
end
