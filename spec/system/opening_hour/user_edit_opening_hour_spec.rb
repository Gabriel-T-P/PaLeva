require 'rails_helper'

describe 'usuário edita horários do estabelecimento' do
  it 'pela página principal do estabelecimento' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
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
  
  it 'com sucesso' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
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
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
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
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
    establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user1, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste INC', trade_name: "TestTeste", full_address: "Av Teste, 123", user: user2, cnpj: CNPJ.generate, 
                                          email: 'teste123@email.com', phone_number: '99999043113')
    opening_hour = OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment2)

    # Act
    login_as user1
    visit edit_establishment_opening_hour_path(establishment2, opening_hour)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'
  end
end
