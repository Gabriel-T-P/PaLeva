require 'rails_helper'

describe 'usuário edita prato' do
  it 'pela tela principal do estabelecimento' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Beverages' do
      click_on 'Cerveja'
    end
    click_on 'Editar'

    # Assert
    expect(page).to have_field 'Nome da Bebida'
    expect(page).to have_field 'Descrição' 
    expect(page).to have_field 'Calorias'
    expect(page).to have_field 'Escolher Imagem'
    expect(page).to have_field 'Alcoólica'
    expect(page).to have_button 'Salvar Bebida'
  end
  
  it 'com sucesso' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Beverages' do
      click_on 'Cerveja'
    end
    click_on 'Editar'
    fill_in 'Nome da Bebida',	with: 'Suco de Laranja'
    fill_in 'Descrição', with: 'Suco mais refrescante de todos'
    fill_in 'Calorias',	with: '120'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Bebida editada com sucesso'  
    expect(page).to have_content 'Suco de Laranja'
    expect(page).to have_content 'Suco mais refrescante de todos' 
    expect(page).to have_content '120 cal'    
  end

  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)

    visit edit_establishment_beverage_path(establishment, beverage)

    expect(current_path).to eq new_user_session_path
  end

  it 'e não é admin do estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
    user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)

    login_as user2
    visit edit_establishment_beverage_path(establishment, beverage)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'  
  end

  it 'e imagem com sucesso' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Beverage.create!(name: 'Cerveja', description: 'Mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Beverages' do
      click_on 'Cerveja'
    end
    click_on 'Editar'
    attach_file 'Escolher Imagem', Rails.root.join('spec', 'support', 'teste2.png')
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Bebida editada com sucesso'  
    expect(page).to have_content 'Cerveja'
    expect(page).to have_content 'Mais comum do Brasil' 
    expect(page).to have_css 'img[src*="teste2.png"]'
  end


  it 'e altera Alcoólicidade da bebida' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Beverages' do
      click_on 'Cerveja'
    end
    click_on 'Editar'
    uncheck 'Alcoólica'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Bebida editada com sucesso'  
    expect(page).not_to have_content 'Alcoólica'
  end
  
  it 'e não pode alterar pedido de outro estabelecimento' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: "teste teste", full_address: "Av teste, 123", cnpj: CNPJ.generate, 
                                          email: 'teste123@email.com', phone_number: '99999043113')
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment2, alcoholic: true)

    # Act
    login_as user
    visit "/establishments/#{establishment2.id}/items/#{beverage.id}/edit"

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'
  end
  
  it 'e vê mensagens de erro' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Beverages' do
      click_on 'Cerveja'
    end
    click_on 'Editar'
    fill_in 'Nome da Bebida',	with: ''
    fill_in 'Descrição',	with: '' 
    fill_in 'Calorias',	with: ''
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Nome da Bebida não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'  
    expect(page).to have_content 'Calorias não pode ficar em branco'
    expect(page).to have_content 'Calorias não é um número'
  end
end
