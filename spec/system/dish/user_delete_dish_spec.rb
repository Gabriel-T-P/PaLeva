require 'rails_helper'

describe 'usuário deleta prato' do
  it 'pela página inicial do estabelecimento' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

    # Assert
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Dishs' do
      click_on 'Lasanha'
    end
    click_on 'Deletar'

    # Act
    expect(current_path).to eq establishment_path(establishment)
    expect(page).to have_content 'Deletado com sucesso'  
    expect(page).not_to have_content 'Lasanha'
    expect(page).not_to have_content 'Alma do macarrão'
    expect(page).not_to have_content '400 cal'
  end
  
  it 'porém não existem pratos cadastrados' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    # Assert
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    
    # Assert
    expect(page).not_to have_button 'Deletar'
  end
  
end
