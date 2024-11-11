require 'rails_helper'

describe 'usuário admin realiza pré cadastro de funcionário' do
  it 'pela sidebar do usuário' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: 'Rio Branco, Deodoro', user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    login_as user
    visit root_path
    click_on 'Cadastros'
    click_on 'Funcionários'
    
    expect(page).to have_content 'Criar Pré-Cadastro'  
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'CPF'
    expect(page).to have_button 'Salvar'
  end

  it 'e não é admin' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'employee')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: 'Rio Branco, Deodoro', user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    login_as user
    visit root_path
    
    expect(page).not_to have_button 'Cadastros'
  end
  
  it 'com sucesso' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: 'Rio Branco, Deodoro', user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    login_as user
    visit root_path
    click_on 'Cadastros'
    click_on 'Funcionários'
    fill_in 'E-mail',	with: 'teste132@email.com' 
    fill_in 'CPF',	with: CPF.generate 
    click_on 'Salvar'

    expect(current_path).to eq root_path  
    expect(page).to have_content 'Pré-Cadastro registrado'
  end
  
  it 'e clica em cancelar' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: 'Rio Branco, Deodoro', user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    login_as user
    visit root_path
    click_on 'Cadastros'
    click_on 'Funcionários'
    click_on 'Cancelar'

    expect(current_path).to eq root_path
    expect(page).not_to have_content 'Pré-Cadastro registrado'
  end
  
end
