require 'rails_helper'

describe 'usuário desloga' do

  it 'a partir da tela inicial' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

    # Act
    login_as user, :scope => :user
    visit root_path

    # Assert
    within 'header/nav' do
      expect(page).to have_content 'Carlos'  
      expect(page).to have_button 'Sair'
      expect(page).not_to have_link 'Entrar'
    end
    
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

    # Act
    login_as user, :scope => :user
    visit root_path
    click_on 'Sair'

    # Assert
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'Carlos'
    expect(page).to have_content 'Logout efetuado com sucesso.'
    
  end
  
  
  
end
