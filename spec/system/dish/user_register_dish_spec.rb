require 'rails_helper'

describe 'usuário cadastra prato' do
  it 'pela página do estabelecimento' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Adicionar Novo Prato'

    # Assert
    expect(page).to have_field 'Nome do Item'
    expect(page).to have_field 'Descrição' 
    expect(page).to have_field 'Calorias'
    expect(page).to have_field 'Cadastrar Imagem'
    expect(page).to have_button 'Salvar'
  end

  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    
    visit new_establishment_item_path(establishment)

    expect(current_path).to eq new_user_session_path  
  end

  it 'e não é admin do estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
    user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)

    login_as user2
    visit new_establishment_item_path(establishment)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'  
  end

  it 'com sucesso' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Adicionar Novo Prato'
    fill_in 'Nome do Item',	with: 'Lasanha'
    fill_in 'Descrição',	with: 'Macarrão, carne moída ou frango e molho' 
    fill_in 'Calorias',	with: '400'
    attach_file 'Cadastrar Imagem', Rails.root.join('spec', 'support', 'test.jpg')
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Prato cadastrado com sucesso'
    within '#Dishs' do
      expect(page).to have_content 'Pratos Cadastrados'
      expect(page).to have_content 'Lasanha'
      expect(page).to have_content 'Macarrão, carne moída ou frango e molho'
      expect(page).to have_content '400 cal'
      expect(page).to have_css 'img[src*="test.jpg"]'
    end
  end  
  
  it ' e não cadastra imagem' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Adicionar Novo Prato'
    fill_in 'Nome do Item',	with: 'Lasanha'
    fill_in 'Descrição',	with: 'Macarrão, carne moída ou frango e molho' 
    fill_in 'Calorias',	with: '400'
    click_on 'Salvar'

    expect(page).to have_content 'Prato cadastrado com sucesso'
    within '#Dishs' do
      expect(page).to have_content 'Pratos Cadastrados'
      expect(page).to have_content 'Lasanha'
      expect(page).to have_content 'Macarrão, carne moída ou frango e molho'
      expect(page).to have_content '400 cal'
      expect(page).to have_content 'Nenhuma imagem encontrada'
    end
  end
  

  it 'e vê mensagens de erro' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Adicionar Novo Prato'
    fill_in 'Nome do Item',	with: ''
    fill_in 'Descrição',	with: '' 
    fill_in 'Calorias',	with: ''
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Nome do Item não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'  
    expect(page).to have_content 'Calorias não pode ficar em branco'
    expect(page).to have_content 'Calorias não é um número'
  end
  

  it 'e não vê nenhuma bebida' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Adicionar Novo Prato'
    fill_in 'Nome do Item',	with: 'Lasanha'
    fill_in 'Descrição',	with: 'Macarrão, carne moída ou frango e molho' 
    fill_in 'Calorias',	with: '400'
    click_on 'Salvar'

    # Assert
    within '#Dishs' do
      expect(page).to have_content 'Lasanha'
      expect(page).to have_content 'Macarrão, carne moída ou frango e molho'
      expect(page).to have_content '400 cal'
    end
    within '#Beverages' do
      expect(page).to have_content 'Nenhuma bebida cadastrada encontrada'  
    end
  end

  it 'no estabelecimento de outro usuário' do
    # Arrange
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", cnpj: CNPJ.generate, 
                                          email: 'teste123@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)

    # Act
    login_as user1
    visit new_establishment_item_path(establishment2)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'
  end
  
end
