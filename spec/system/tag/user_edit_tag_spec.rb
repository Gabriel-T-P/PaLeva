require 'rails_helper'

describe 'usuário edita marcador' do
  it 'pela user sidebar' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
    tag1 = Tag.create!(name: 'Picante')

    login_as user
    visit tags_path
    click_on 'Editar'

    expect(current_path).to eq edit_tag_path(tag1)
    expect(page).to have_field 'Nome'  
    expect(page).to have_field 'Descrição'  
    expect(page).to have_button 'Salvar'
  end
  
  it 'e usuário não está logado' do
    tag = Tag.create!(name: 'Picante')
    
    visit edit_tag_path(tag)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'    
  end
  
  it 'e usuário não é admin' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = Employee.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    tag = Tag.create!(name: 'Picante')

    login_as user
    visit edit_tag_path(tag)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'    
  end
  
  it 'com sucesso' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
    tag = Tag.create!(name: 'Picante')

    login_as user
    visit edit_tag_path(tag)
    fill_in 'Nome',	with: 'sometext'
    fill_in 'Descrição',	with: 'sometext 2'
    click_on 'Salvar'

    expect(current_path).to eq tags_path
    expect(page).to have_content 'Marcador editado com sucesso'
    expect(page).to have_content 'sometext'  
    expect(page).to have_content 'sometext 2'
  end

  it 'e vê mensagens de erros' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
    tag = Tag.create!(name: 'Picante')

    login_as user
    visit edit_tag_path(tag)
    fill_in 'Nome',	with: '' 
    fill_in 'Descrição',	with: 'sometext 2'
    click_on 'Salvar'

    expect(page).to have_content 'Falha ao editar o marcador'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end
  
end
