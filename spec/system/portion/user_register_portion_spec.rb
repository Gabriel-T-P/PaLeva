require 'rails_helper'

describe 'usuário cadastra porção' do
  it 'pela página do modelo do item a ser criado como bebida' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    beverage = Beverage.create!(name: 'Cerveja', description: 'Bebida alcoólica mais comum do Brasil', calories: '140', item_type: 'beverage', 
                                establishment: establishment, alcoholic: true)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Beverages' do
      click_on 'Cerveja'
    end
    click_on 'Adicionar Porção'

    # Assert
    expect(page).to have_content 'Nova Porção para a Bebida Cerveja'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Preço'
  end
  
  it 'pela página do modelo do item a ser criado como prato' do
    # Arrange
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', 
                                establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    within '#Dishs' do
      click_on 'Lasanha'
    end
    click_on 'Adicionar Porção'

    # Assert
    expect(page).to have_content 'Nova Porção para o Prato Lasanha'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Preço'
  end

  it 'com sucesso como uma bebida' do
    
  end
  
end
