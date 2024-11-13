require 'rails_helper'

describe 'usuário vê histórico de preços' do
  it 'pela página da porção de um prato' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)

    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Lasanha'
    click_on 'Meia Lasanha'

    expect(page).to have_content 'Histórico de Preços'
    expect(page).to have_content 'Preço'
    expect(page).to have_content 'Data de Adição'
    expect(page).to have_content 'Data de Remoção'
    expect(page).to have_content 'Status'
    expect(page).to have_content '7,50'
    expect(page).to have_content 'Atual'
  end
  
  it 'pela página da porção de uma bebida' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
    portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)

    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Água'
    click_on 'Água 250 ml'

    expect(page).to have_content 'Histórico de Preços'
    expect(page).to have_content 'Preço'
    expect(page).to have_content 'Data de Adição'
    expect(page).to have_content 'Data de Remoção'
    expect(page).to have_content 'Status'
    expect(page).to have_content '2,50'
    expect(page).to have_content 'Atual'
  end
  
  it 'e vê um preço antigo com current false' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
    portion.update(price: 8.99)

    login_as user
    visit root_path
    click_on 'Meu Estabelecimento'
    click_on 'Lasanha'
    click_on 'Meia Lasanha'

    expect(page).to have_content 'Data de Adição'
    expect(page).to have_content 'Data de Remoção'
    expect(page).to have_content 'Status'
    expect(page).to have_content 'Preço'
    expect(page).to have_content 'Removido'
    expect(page).to have_content '8,99'    
  end
  
end
