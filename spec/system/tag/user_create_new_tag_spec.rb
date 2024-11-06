require 'rails_helper'

describe 'usuário cria nova tag' do
  it 'pela nav' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    login_as user
    visit root_path
    within 'nav' do
      click_on 'Cadastros'
      click_on 'Marcadores'
    end
    
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_button 'Salvar Marcador'
  end
  
  it 'e usuário não está logado' do
    
    visit new_tag_path

    expect(current_path).to eq new_user_session_path  
  end
  
  it 'e não vê botão de cadastros de tag na nav pois não está logado' do

    visit new_tag_path

    expect(page).not_to have_button 'Cadastros'  
  end
  
  it 'com sucesso' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    login_as user
    visit new_tag_path
    fill_in 'Nome',	with: 'Picante'
    fill_in 'Descrição',	with: 'picancia moderada em pratos ou bebidas'
    click_on 'Salvar Marcador'

    expect(current_path).to eq root_path  
    expect(page).to have_content 'Marcador criado com sucesso'
  end
  
  it 'e clica em cancelar' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    login_as user
    visit new_tag_path
    click_on 'Cancelar'

    expect(current_path).to eq root_path
    expect(page).not_to have_content 'Marcador criado com sucesso'
  end
  
  it 'e vê mensagens de erros' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    login_as user
    visit new_tag_path
    fill_in 'Nome',	with: ''
    fill_in 'Descrição',	with: ''
    click_on 'Salvar Marcador'

    expect(page).to have_content 'Falha ao criar o marcador'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).not_to have_content 'Descrição não pode ficar em branco'
  end
  
end
