require 'rails_helper'

describe 'usuário remove tag' do
  it 'pela página do prato' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
    tag = Tag.create!(name: 'Picante', description: 'moderadamente picante para pratos e talvez bebidas')
    ItemTag.create!(item: dish, tag: tag)

    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Lasanha'
    find("##{dom_id(tag)}").click

    expect(page).to have_content 'Marcador removido do prato'
    expect(page).not_to have_content 'Picante' 
  end
    
  it 'pela página da bebida' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    beverage = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                establishment: establishment, alcoholic: false)
    tag = Tag.create!(name: 'Refrescante', description: 'bebida refrescante')
    ItemTag.create!(item: beverage, tag: tag)

    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Limonada'
    find("##{dom_id(tag)}").click

    expect(page).to have_content 'Marcador removido da bebida'
    expect(page).not_to have_content 'Refrescante' 
  end
end