require 'rails_helper'

describe 'usuário edita estabelecimento' do
  it 'a partir da tela inicial do estabelecimento' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#EstablishmentInfos' do
      click_on 'Editar Informações'  
    end

    # Assert
    expect(page).to have_field 'Razão Social'
    expect(page).to have_field 'Nome Fantasia'  
    expect(page).to have_field 'CNPJ'  
    expect(page).to have_field 'Endereço'  
    expect(page).to have_field 'Número de Telefone'  
    expect(page).to have_field 'E-mail'
    expect(page).to have_button 'Cadastrar' 
  end

  it 'e deve estar autenticado para aparecer botão' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Meu Estabelecimento' 
  end

  it 'e deve estar autenticado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    visit edit_establishment_path(establishment)
    
    expect(current_path).to eq new_user_session_path
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
    click_on 'Editar Informações'
    fill_in 'Razão Social',	with: 'Teste123'
    fill_in 'Nome Fantasia',	with: 'Café Carlitos'
    fill_in 'CNPJ',	with: '74.316.733/0001-76'
    fill_in 'Endereço',	with: 'Av Teste, 123'
    fill_in 'Número de Telefone',	with: '11_1111_1111'
    fill_in 'E-mail',	with: 'teste1223112@email.com'
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'Atualizado com sucesso'
    expect(page).to have_content 'Razão Social: Teste123'
    expect(page).to have_content 'Nome Fantasia: Café Carlitos'  
    expect(page).to have_content 'CNPJ: 74.316.733/0001-76'  
    expect(page).to have_content 'Endereço: Av Teste, 123'  
    expect(page).to have_content 'Número de Telefone: 11_1111_1111'  
    expect(page).to have_content 'E-mail: teste1223112@email.com'
  end
  
  it 'e vê mensagens de erros' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Editar Informações'
    fill_in 'Razão Social',	with: ''
    fill_in 'Nome Fantasia',	with: ''
    fill_in 'CNPJ',	with: ''
    fill_in 'Endereço',	with: ''
    fill_in 'Número de Telefone',	with: ''
    fill_in 'E-mail',	with: ''
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'Erro ao atualizar os dados'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'  
    expect(page).to have_content 'CNPJ não pode ficar em branco'  
    expect(page).to have_content 'Endereço não pode ficar em branco'  
    expect(page).to have_content 'Número de Telefone não pode ficar em branco'  
    expect(page).to have_content 'E-mail não pode ficar em branco'
  end
  
  it 'e não pode alterar email para um já existente' do
    # Arrange
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: "Teste's Café", full_address: "Av Teste, 123", cnpj: CNPJ.generate, 
                                            email: 'teste123@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)

    # Act
    login_as user1
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Editar Informações'
    fill_in 'E-mail',	with: 'teste123@email.com'
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'Erro ao atualizar os dados' 
    expect(page).to have_content 'E-mail já está em uso'
  end
  
  it 'com erro de CNPJ inválido' do
    # Arrange
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: "Teste's Café", full_address: "Av Teste, 123", cnpj: CNPJ.generate, 
                                            email: 'teste123@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)

    # Act
    login_as user2
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Editar Informações'
    fill_in 'CNPJ',	with: '42.182.510/0001-77'
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content 'Erro ao atualizar os dados' 
    expect(page).to have_content 'CNPJ já está em uso'
  end
end
