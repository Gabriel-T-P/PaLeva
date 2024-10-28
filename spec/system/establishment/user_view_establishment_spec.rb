require 'rails_helper'

describe 'usuário visita informações do estabelecimento' do
  it 'pela página inicial' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDEF')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                      email: 'carlosjonas@email.com', phone_number: '99999043113')

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    expect(page).to have_content 'Razão Social: Carlos LTDA'
    expect(page).to have_content "Nome Fantasia: Carlo's Café"  
    expect(page).to have_content 'CNPJ: 42.182.510/0001-77'  
    expect(page).to have_content 'Endereço: Rio Branco, Deodoro'  
    expect(page).to have_content 'Número de Telefone: 99999043113'  
    expect(page).to have_content 'E-mail: carlosjonas@email.com'
    expect(page).to have_content 'Código: ABCDEF'
  end
  
  it 'e não possui acesso àquele estabelecimento' do
    # Arrange
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste23@email.com', password: '1234567891011')
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user1, cnpj: '42.182.510/0001-77', 
                                      email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Burguer", full_address: "CDS street, Castelo", user: user2, cnpj: '06.738.237/0001-50', 
                                      email: 'carlosburguer@email.com', phone_number: '99999043113')

    # Act
    login_as user2
    visit establishment_path(establishment1)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'    
  end
  
  it 'e não pode cadastrar novo estabelecimento' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')

    # Act
    login_as user
    visit new_establishment_path

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode cadastrar outro estabelecimento'  
  end
  

  it 'e vê botão para horários de funcionamento' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Adicionar Horário de Funcionamento'

    # Assert
    expect(page).to have_field 'Dia da Semana'
    expect(page).to have_field 'Horário de Abertura'
    expect(page).to have_field 'Horário de Fechamento' 
    expect(page).to have_field 'Fechado'
    expect(page).to have_content 'segunda-feira'
    expect(page).to have_content 'terça-feira'  
    expect(page).to have_content 'quarta-feira'  
    expect(page).to have_content 'quinta-feira'  
    expect(page).to have_content 'sexta-feira'  
    expect(page).to have_content 'sábado'  
    expect(page).to have_content 'domingo'

  end
end
