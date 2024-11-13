require 'rails_helper'

describe 'usuário vê status da porção' do
  context 'pelos pratos' do
    it 'pela página do item' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
      other_portion = Portion.create!(name: 'Lasanha Completa', description: 'Lasanha de carne para 4 pessoa', price: 47.50, item: dish)
      other_portion.update(active: false)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
  
      expect(page).to have_button 'Ativo'
      expect(page).to have_button 'Inativo'
    end
    
    it 'e muda status para inativo' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      click_on 'Ativo'
  
      expect(page).to have_content 'Desativado com sucesso'  
      expect(page).to have_content 'Inativo'
      expect(page).not_to have_content 'Ativo'  
    end
    
    it 'e muda status para ativo' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Lasanha Completa', description: 'Lasanha de carne para 4 pessoa', price: 47.50, item: dish)
      portion.update(active: false)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      click_on 'Inativo'
  
      expect(page).to have_content 'Ativado com sucesso'
      expect(page).not_to have_content 'Inativo'
      expect(page).to have_content 'Ativo'
    end
    
  
    it 'pela página da porção' do
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
  
      expect(page).to have_button 'Desativar'
    end
  
    it 'e muda status para Inativo pela página da porção' do
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
      click_on 'Desativar'
  
      expect(current_path).to eq establishment_item_path(establishment, dish)
      expect(page).to have_content 'Desativado com sucesso'
      expect(page).to have_button 'Inativo'
    end
    
    it 'e muda status para Ativo pela página da porção' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
      portion.update(active: false)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      within '#Portions' do
        click_on 'Meia Lasanha'
      end
      click_on 'Ativar'
  
      expect(current_path).to eq establishment_item_path(establishment, dish)
      expect(page).to have_content 'Ativado com sucesso'
      expect(page).to have_button 'Ativo'
    end
  end
  
  context 'pelas bebidas' do
    it 'pela página do item' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)
      other_portion = Portion.create!(name: 'Água 300 ml', description: 'Água mineral em copo plástico de 300ml', price: 5.50, item: beverage)
      other_portion.update(active: false)

      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
  
      expect(page).to have_button 'Ativo'
      expect(page).to have_button 'Inativo'
    end
    
    it 'e muda status para inativo' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)

      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      click_on 'Ativo'
  
      expect(page).to have_content 'Desativado com sucesso'
      expect(page).to have_content 'Inativo'
      expect(page).not_to have_content 'Ativo' 
    end
    
    it 'e muda status para ativo' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)
      portion.update(active: false)

      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      click_on 'Inativo'
  
      expect(page).to have_content 'Ativado com sucesso'
      expect(page).not_to have_content 'Inativo'
      expect(page).to have_content 'Ativo'
    end
    
    it 'pela página da porção' do
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
  
      expect(page).to have_button 'Desativar'
    end
    
    it 'e muda status para Inativo pela página da porção' do
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
      click_on 'Desativar'
  
      expect(current_path).to eq establishment_beverage_path(establishment, beverage)
      expect(page).to have_content 'Desativado com sucesso'
      expect(page).to have_button 'Inativo'
    end
    
    it 'e muda status para Ativo pela página da porção' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)
      portion.update(active: false)

      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      within '#Portions' do
        click_on 'Água 250 ml'
      end
      click_on 'Ativar'
  
      expect(current_path).to eq establishment_beverage_path(establishment, beverage)
      expect(page).to have_content 'Ativado com sucesso'
      expect(page).to have_button 'Ativo'
    end
    
  end
end
