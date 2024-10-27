require 'rails_helper'

describe 'usuário deleta bebida' do
  it 'pela página inicial do estabelecimento' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: '42.182.510/0001-77', 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    beverage = Item.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', establishment: establishment, alcoholic: true)

    # Assert
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Beverages' do
      click_on 'Deletar'
    end

    # Act
    expect(current_path).to eq establishment_path(establishment)
    expect(page).to have_content 'Bebida deletada com sucesso'  
    expect(page).not_to have_content 'Cerveja'
    expect(page).not_to have_content 'Bebida alcoólica mais comum do Brasil'
    expect(page).not_to have_content '140 cal'
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
    within '#Beverages' do
      expect(page).not_to have_button 'Deletar'
    end
  end
  
end