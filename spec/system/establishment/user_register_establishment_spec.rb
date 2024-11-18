require 'rails_helper'

describe 'usuário cria novo estabelecimento' do
  it 'obrigatoriamente após registrar conta' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Inscrever-se'
    fill_in 'Nome',	with: 'Carlos'
    fill_in 'Sobrenome',	with: 'Jonas'
    fill_in 'CPF',	with: CPF.generate
    fill_in 'E-mail',	with: 'carlosjonas@email.com'
    fill_in 'Senha',	with: '1234567891011'
    fill_in 'Confirme sua senha',	with: '1234567891011'
    click_on 'Enviar'

    # Assert
    expect(current_path).to eq new_establishment_path
  end

  it 'após ser redirecionado se não houver um cadastrado' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

    # Act
    login_as user
    visit root_path

    # Assert
    expect(current_path).to eq new_establishment_path
    expect(page).to have_field 'Razão Social'
    expect(page).to have_field 'Nome Fantasia'  
    expect(page).to have_field 'CNPJ'  
    expect(page).to have_field 'Endereço'  
    expect(page).to have_field 'Número de Telefone'  
    expect(page).to have_field 'E-mail'
    expect(page).to have_button 'Cadastrar'
    expect(page).not_to have_link 'Cancelar'  
  end

  it 'e não está logado' do
    
    visit new_establishment_path

    expect(current_path).to eq new_user_session_path  
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '12345678')

    # Act
    login_as user
    visit new_establishment_path
    fill_in 'Razão Social',	with: 'Carlos Burguer LTDA'
    fill_in 'Nome Fantasia',	with: 'Carlos Burguer'
    fill_in 'CNPJ',	with: '42.182.510/0001-77'
    fill_in 'Endereço',	with: 'Rio Branco, Deodoro'
    fill_in 'Número de Telefone',	with: '11_1111_1111'
    fill_in 'E-mail',	with: 'carlos_burguer@email.com'
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'Estabelecimento criado com sucesso'
    expect(page).to have_content 'Razão Social: Carlos Burguer LTDA'
    expect(page).to have_content 'Nome Fantasia: Carlos Burguer'  
    expect(page).to have_content 'CNPJ: 42.182.510/0001-77'  
    expect(page).to have_content 'Endereço: Rio Branco, Deodoro'  
    expect(page).to have_content 'Número de Telefone: 11_1111_1111'  
    expect(page).to have_content 'E-mail: carlos_burguer@email.com'
  end
  
  it 'com erros de presença visíveis' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

    # Act
    login_as user
    visit root_path
    fill_in 'Razão Social',	with: ''
    fill_in 'Nome Fantasia',	with: ''
    fill_in 'CNPJ',	with: ''
    fill_in 'Endereço',	with: ''
    fill_in 'Número de Telefone',	with: ''
    fill_in 'E-mail',	with: ''
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'Cadastro não foi concluído'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'  
    expect(page).to have_content 'CNPJ não pode ficar em branco'  
    expect(page).to have_content 'Endereço não pode ficar em branco'  
    expect(page).to have_content 'Número de Telefone não pode ficar em branco'  
    expect(page).to have_content 'E-mail não pode ficar em branco'
  end
  
  it 'com erro de E-mail inválido' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

    # Act
    login_as user
    visit new_establishment_path
    fill_in 'Razão Social',	with: 'Carlos Burguer LTDA'
    fill_in 'Nome Fantasia',	with: 'Carlos Burguer'
    fill_in 'CNPJ',	with: '42.182.510/0001-77'
    fill_in 'Endereço',	with: 'Rio Branco, Deodoro'
    fill_in 'Número de Telefone',	with: '11_1111_1111'
    fill_in 'E-mail',	with: 'carlos&burguer@email.com'
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'Cadastro não foi concluído' 
    expect(page).to have_content 'E-mail não é válido'
  end
  
  it 'com erro de CNPJ inválido' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

    # Act
    login_as user
    visit new_establishment_path
    fill_in 'Razão Social',	with: 'Carlos Burguer LTDA'
    fill_in 'Nome Fantasia',	with: 'Carlos Burguer'
    fill_in 'CNPJ',	with: '00.100.000/0000-00'
    fill_in 'Endereço',	with: 'Rio Branco, Deodoro'
    fill_in 'Número de Telefone',	with: '11_1111_1111'
    fill_in 'E-mail',	with: 'carlos_burguer@email.com'
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'Cadastro não foi concluído' 
    expect(page).to have_content 'CNPJ não é válido'
  end
  
  it 'e o usuário que criou o estabelecimento recebe o estabelecimento' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

    login_as user
    visit new_establishment_path
    fill_in 'Razão Social',	with: 'Carlos Burguer LTDA'
    fill_in 'Nome Fantasia',	with: 'Carlos Burguer'
    fill_in 'CNPJ',	with: '42.182.510/0001-77'
    fill_in 'Endereço',	with: 'Rio Branco, Deodoro'
    fill_in 'Número de Telefone',	with: '11_1111_1111'
    fill_in 'E-mail',	with: 'carlos_burguer@email.com'
    click_on 'Cadastrar'

    expect(user.establishment.nil?).to be false
  end

  it 'e o usuário que criou o estabelecimento é feito admin dele' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

    login_as user
    visit new_establishment_path
    fill_in 'Razão Social',	with: 'Carlos Burguer LTDA'
    fill_in 'Nome Fantasia',	with: 'Carlos Burguer'
    fill_in 'CNPJ',	with: '42.182.510/0001-77'
    fill_in 'Endereço',	with: 'Rio Branco, Deodoro'
    fill_in 'Número de Telefone',	with: '11_1111_1111'
    fill_in 'E-mail',	with: 'carlos_burguer@email.com'
    click_on 'Cadastrar'

    expect(user.establishment.admin_user).to eq user.id
  end
end
