require 'rails_helper'

describe 'usuário vê lista de marcadores' do
  it 'pelo user sidebar' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
    tag1 = Tag.create!(name: 'Picante')
    tag2 = Tag.create!(name: 'Teste1')
    tag3 = Tag.create!(name: 'Teste2')

    login_as user
    visit root_path
    within '#UserSidebar' do
      click_on 'Marcador'
    end

    expect(current_path).to eq tags_path
    expect(page).to have_content 'Lista de Marcadores'
    expect(page).to have_content 'Picante'      
    expect(page).to have_content 'Teste1'      
    expect(page).to have_content 'Teste2'      
  end
  
  it 'e usuário não logado' do
    
    visit tags_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se' 
  end
  
  it 'e não é admin' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = Employee.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    login_as user
    visit tags_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'    
  end
  
  it 'e pode acessar página de edição de uma tag' do
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
end
