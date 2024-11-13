require 'rails_helper'

describe 'usuário deleta porção' do
  context 'pelos pratos' do
    it 'e vê botão deletar' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      within '#Portions' do
        click_on 'Meia Lasanha'
      end

      expect(page).to have_button 'Deletar'
    end
    
    it 'com sucesso' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      within '#Portions' do
        click_on 'Meia Lasanha'
      end
      click_on 'Deletar'

      expect(current_path).to eq establishment_item_path(establishment, dish)
      expect(page).not_to have_content 'Meia Lasanha'
      expect(page).not_to have_content 'Lasanha de carne para 1 pessoa'  
      expect(page).not_to have_content '7,50'
    end
  end
  
  context 'pelas bebidas' do
    it 'e vê botão de deletar' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      within '#Portions' do
        click_on 'Água 250 ml'
      end

      expect(page).to have_button 'Deletar'  
    end
    
    it 'com sucesso' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)

      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      within '#Portions' do
        click_on 'Água 250 ml'
      end
      click_on 'Deletar'

      expect(current_path).to eq establishment_beverage_path(establishment, beverage)
      expect(page).not_to have_content 'Água 250 ml'
      expect(page).not_to have_content 'Água mineral em copo plástico de 250ml'  
      expect(page).not_to have_content '2,50'
    end
  end
end
