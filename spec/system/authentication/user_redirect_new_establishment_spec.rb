require 'rails_helper'

describe 'usuário não está logado' do
  it 'e acessa tela de login' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar'

    # Assert
    expect(current_path).to eq new_user_session_path
  end
  
end

describe 'usuário está logado e não tem estabelecimento' do
  it 'e acessa tela inicial' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

    # Act
    login_as user
    visit root_path

    # Assert
    expect(current_path).to eq new_establishment_path
    expect(page).to have_content 'Você precisa completar o cadastro do estabelecimento'
  end
  
  it 'e acessa tela de login' do
  # Arrange
  user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
  
  # Act
  login_as user
  visit new_user_session_path

  # Assert
  expect(current_path).to eq new_establishment_path  
  end

  it 'e acessa tela de novo estabelecimento' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
  
    login_as user
    visit new_establishment_path

    expect(current_path).to eq new_establishment_path 
  end
  
  it 'e acessa tela de novo pedido' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
  
    login_as user
    visit new_order_path

    expect(current_path).to eq new_establishment_path 
  end
  
  it 'e acessa tela de nova tag' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
  
    login_as user
    visit new_tag_path

    expect(current_path).to eq new_establishment_path 
  end
  
  it 'e acessa tela de novo menu' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
  
    login_as user
    visit new_menu_path

    expect(current_path).to eq new_establishment_path 
  end
  
  it 'e acessa tela de novo funcionário' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
  
    login_as user
    visit new_employee_path

    expect(current_path).to eq new_establishment_path 
  end
  
end

describe 'usuário está logado e tem estabelecimento' do
  it 'e acessa tela inicial' do
    # Arrange
    establishment = Establishment.create(corporate_name: 'Carloss LTDA', trade_name: "Carlos's Cafe", full_address: "123 Main St", cnpj: '33.113.309/0001-47', 
                                         email: 'carlosjonas@email.com', phone_number: '99999043113', code: '12456')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit root_path

    # Assert
    expect(current_path).to eq root_path
  end
  
end


