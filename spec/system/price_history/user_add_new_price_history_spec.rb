require 'rails_helper'

describe 'usuário cria um histórico' do
  context 'ao criar' do
    it 'uma porção de um prato' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      within '#Dishs' do
        click_on 'Lasanha'
      end
      click_on 'Adicionar Porção'
      fill_in 'Nome',	with: 'Lasanha Média'
      fill_in 'Descrição',	with: 'Lasanha de carne e molho bolonhesa, server 2 pessoas' 
      fill_in 'Preço',	with: '30.99'
      click_on 'Salvar Porção'
  
      expect(dish.portions.first.price_histories.present?).to be true
    end
    
    it 'uma porção de uma bebida' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Item.create!(name: 'Limonada', description: 'Limonada Natural', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      within '#Beverages' do
        click_on 'Limonada'
      end
      click_on 'Adicionar Porção'
      fill_in 'Nome',	with: 'Limonada Média'
      fill_in 'Descrição',	with: 'Limonada, server 2 pessoas' 
      fill_in 'Preço',	with: '8.99'
      click_on 'Salvar Porção'
  
      expect(beverage.portions.first.price_histories.first.price).to eq 8.99
    end
  end
  
  context 'ao editar' do
    it 'uma porção de um prato' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      within '#Dishs' do
        click_on 'Lasanha'
      end
      click_on 'Meia Lasanha'
      click_on 'Editar'
      fill_in 'Nome',	with: 'Lasanha Média'
      fill_in 'Descrição',	with: 'Lasanha de carne e molho bolonhesa, server 2 pessoas' 
      fill_in 'Preço',	with: '30.99'
      click_on 'Salvar Porção'
  
      expect(dish.portions.first.price_histories.size).to eq 2
    end
    
    it 'uma porção de uma bebida' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Item.create!(name: 'Limonada', description: 'Limonada Natural', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Limonada 250 ml', description: 'Limonada em copo plástico de 250ml', price: 2.50, item: beverage)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      within '#Beverages' do
        click_on 'Limonada'
      end
      click_on 'Limonada 250 ml'
      click_on 'Editar'
      fill_in 'Nome',	with: 'Limonada Média'
      fill_in 'Descrição',	with: 'Limonada, server 2 pessoas' 
      fill_in 'Preço',	with: '2.99'
      click_on 'Salvar Porção'
  
      expect(portion.price_histories.last.price).to eq 2.99
      expect(portion.price_histories.first.current).to be false  
      expect(portion.price_histories.last.current).to be true  
    end
  end
end
