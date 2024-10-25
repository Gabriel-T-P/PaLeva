require 'rails_helper'

describe 'usuário faz o cadastro' do

  it 'pela página inicial' do
    # Arrange

    # Act
    visit root_path
    within 'header/nav' do
      click_on 'Entrar'
    end
    click_on 'Inscrever-se'

    # Assert
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Sobrenome'
    expect(page).to have_field 'CPF'
    expect(page).to have_button 'Enviar'  
    
  end

  it 'com sucesso' do
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
    expect(page).to have_content 'Carlos'
    expect(page).to have_content 'Você realizou seu registro com sucesso.' 
    expect(page).to have_button 'Sair'
    expect(page).not_to have_link 'Entrar'        
    
  end
  
end
