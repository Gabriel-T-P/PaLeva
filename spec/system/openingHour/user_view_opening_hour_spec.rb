require 'rails_helper'

describe 'usuário vê horários' do
  it 'pela página inicial do estabelecimento' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    opening_hour = OpeningHour.create!(day_of_week: 0, closed: true, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    # Arrange
    expect(page).to have_content 'domingo'
    expect(page).to have_content 'Fechado'
  end
  

  it 'e quando existem 7 horários criados botão de adicionar horário desaparece' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    OpeningHour.create!(day_of_week: 0, closed: true, establishment: establishment)
    OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment)
    OpeningHour.create!(day_of_week: 2, closed: true, establishment: establishment)
    OpeningHour.create!(day_of_week: 3, closed: true, establishment: establishment)
    OpeningHour.create!(day_of_week: 4, closed: true, establishment: establishment)
    OpeningHour.create!(day_of_week: 5, closed: true, establishment: establishment)
    OpeningHour.create!(day_of_week: 6, closed: true, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    # Assert
    expect(page).not_to have_link 'Adicionar Horário de Funcionamento'
  end
end
