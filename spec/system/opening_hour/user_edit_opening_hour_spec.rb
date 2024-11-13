require 'rails_helper'

describe 'usuário edita horários do estabelecimento' do
  it 'pela página principal do estabelecimento' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    opening_hour = OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#OpeningHours' do
      click_on 'Editar'
    end

    # Assert
    expect(current_path).to eq edit_establishment_opening_hour_path(establishment, opening_hour)
    expect(page).to have_content 'Editar Horário'
    expect(page).to have_field 'Dia da Semana'
    expect(page).to have_field 'Horário de Abertura'
    expect(page).to have_field 'Horário de Fechamento'
    expect(page).to have_button 'Salvar Horário'            
  end
  
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    opening_hour = OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment)

    visit edit_establishment_opening_hour_path(establishment, opening_hour)

    expect(current_path).to eq new_user_session_path  
  end

  it 'e não é admin' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
    user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)
    opening_hour = OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment)

    login_as user2
    visit edit_establishment_opening_hour_path(establishment, opening_hour)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'
  end

  it 'com sucesso' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    opening_hour = OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#OpeningHours' do
      click_on 'Editar'
    end
    select 'domingo', from: 'Dia da Semana' 
    click_on 'Salvar Horário'

    # Assert
    expect(page).not_to have_content 'segunda-feira'
    expect(page).to have_content 'domingo'
    expect(page).to have_content 'Fechado' 
  end

  it 'e vê mensagens de erro' do
    # Arrange
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    opening_hour = OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#OpeningHours' do
      click_on 'Editar'
    end
    uncheck 'Fechado'
    fill_in 'Horário de Abertura',	with: ''
    fill_in 'Horário de Fechamento',	with: '' 
    click_on 'Salvar Horário'

    # Assert
    expect(page).to have_content 'Horário de Abertura não pode ficar em branco'
    expect(page).to have_content 'Horário de Fechamento não pode ficar em branco'
  end

  it 'no estabelecimento de outro usuário' do
    # Arrange
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", cnpj: CNPJ.generate, 
                                          email: 'teste123@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
    opening_hour = OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment2)

    # Act
    login_as user1
    visit edit_establishment_opening_hour_path(establishment2, opening_hour)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'
  end
end
