require 'rails_helper'

describe 'usuário cadastra horário de abertura' do
  it 'pela página do estabelecimento' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

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
    expect(page).to have_button 'Salvar Horário'
  end
  
  it 'e não existem horários cadastrados' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    expect(page).to have_content 'Por favor adicione um horário de funcionamento'  
  end

  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    visit new_establishment_opening_hour_path(establishment)

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
    click_on 'Adicionar Horário de Funcionamento'
    select 'segunda-feira',	from: 'Dia da Semana'
    fill_in 'Horário de Abertura',	with: '08:00' 
    fill_in 'Horário de Fechamento',	with: '20:00'
    click_on 'Salvar Horário'
    
    # Assert
    expect(current_path).to eq establishment_path(establishment)
    expect(page).to have_content 'Horário adicionado com sucesso'
    expect(page).to have_content 'segunda-feira'
    expect(page).to have_content '08:00 às 20:00 horas'
  end
  
  it 'com dia fechado' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Adicionar Horário de Funcionamento'
    select 'segunda-feira',	from: 'Dia da Semana'
    check 'Fechado'
    click_on 'Salvar Horário'

    # Assert
    expect(page).to have_content 'segunda-feira'
    expect(page).to have_content 'Fechado'    
  end
  
  it 'com 2 dias diferentes' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Adicionar Horário de Funcionamento'
    select 'segunda-feira',	from: 'Dia da Semana'
    fill_in 'Horário de Abertura',	with: '08:00' 
    fill_in 'Horário de Fechamento',	with: '20:00'
    click_on 'Salvar Horário'

    click_on 'Adicionar Horário de Funcionamento'
    select 'terça-feira',	from: 'Dia da Semana'
    fill_in 'Horário de Abertura',	with: '07:00' 
    fill_in 'Horário de Fechamento',	with: '21:00'
    click_on 'Salvar Horário'
    
    # Assert
    expect(current_path).to eq establishment_path(establishment)
    expect(page).to have_content 'Horário adicionado com sucesso'
    expect(page).to have_content 'segunda-feira'
    expect(page).to have_content '08:00 às 20:00 horas'
    expect(page).to have_content 'terça-feira'   
    expect(page).to have_content '07:00 às 21:00 horas'
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
    click_on 'Adicionar Horário de Funcionamento'
    click_on 'Salvar Horário'

    # Assert
    expect(page).to have_content 'Erro ao adicionar o horário'
    expect(page).to have_content 'Horário de Abertura não pode ficar em branco'
    expect(page).to have_content 'Horário de Fechamento não pode ficar em branco'
  end
  
  it 'e vê mensagens de erro do dia da semana em uso' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    opening_hour = OpeningHour.create!(day_of_week: 0, closed: true, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Adicionar Horário de Funcionamento'
    select 'domingo', from: 'Dia da Semana'
    click_on 'Salvar Horário'

    # Assert
    expect(page).to have_content 'Erro ao adicionar o horário'
    expect(page).to have_content 'Dia da Semana Dia da semana já cadastrado, por favor faça a edição do dia ao ínves de um novo cadastro'
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
    visit "/establishments/#{establishment2.id}/opening_hours/new"

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'
  end
end
