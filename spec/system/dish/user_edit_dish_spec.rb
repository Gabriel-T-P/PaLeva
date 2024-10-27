require 'rails_helper'

describe 'usuário edita prato' do
  it 'pela tela do principal do estabelecimento' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'

    within '#Dishs' do
      click_on 'Editar'
    end

    # Assert
    expect(page).to have_field 'Nome do Item'
    expect(page).to have_field 'Descrição' 
    expect(page).to have_field 'Calorias'
    expect(page).to have_field 'Cadastrar Imagem'
    expect(page).to have_button 'Salvar'  
  end
  
  it 'com sucesso' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Dishs' do
      click_on 'Editar'
    end
    fill_in 'Nome do Item',	with: 'Churrasco'
    fill_in 'Descrição', with: 'Carne Bovina da mais saborosa e suculenta'
    fill_in 'Calorias',	with: '452'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Editado com sucesso'  
    expect(page).to have_content 'Churrasco'
    expect(page).to have_content 'Carne Bovina da mais saborosa e suculenta' 
    expect(page).to have_content '452 cal'    
  end
  
  it 'e imagem com sucesso' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Dishs' do
      click_on 'Editar'
    end
    attach_file 'Cadastrar Imagem', Rails.root.join('spec', 'support', 'teste2.png')
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Editado com sucesso'  
    expect(page).to have_content 'Lasanha'
    expect(page).to have_content 'Alma do macarrão' 
    expect(page).to have_css 'img[src*="teste2.png"]'
  end

  it 'e não pode alterar pedido de outro estabelecimento' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
    establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: "teste teste", full_address: "Av teste, 123", user: user2, cnpj: CNPJ.generate, 
                                          email: 'teste123@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment2)

    # Act
    login_as user
    visit "/establishments/#{establishment2.id}/items/#{dish.id}/edit"

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'
  end
  
  it 'e vê mensagens de erro' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Dishs' do
      click_on 'Editar'
    end
    fill_in 'Nome do Item',	with: ''
    fill_in 'Descrição',	with: '' 
    fill_in 'Calorias',	with: ''
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Nome do Item não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'  
    expect(page).to have_content 'Calorias não pode ficar em branco'
    expect(page).to have_content 'Calorias não é um número'
  end
end
