require 'rails_helper'

describe 'usuário edita porção' do
  context 'pela página de pratos' do
    it 'e visualiza botões' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      within '#Portions' do
        click_on 'Meia Lasanha'
      end
      click_on 'Editar'

      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Preço'
      expect(page).to have_content 'Editar Porção de um Prato'
      expect(page).to have_field 'Escolher Imagem'
      expect(page).to have_button 'Salvar Porção'
    end
    
    it 'com sucesso' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      within '#Portions' do
        click_on 'Meia Lasanha'
      end
      click_on 'Editar'
      fill_in 'Nome',	with: 'sometext' 
      fill_in 'Descrição',	with: 'somelargetext' 
      fill_in 'Preço',	with: '12.00'
      click_on 'Salvar Porção'

      expect(current_path).to eq establishment_item_portion_path(establishment, dish, portion)
      expect(page).to have_content 'sometext'
      expect(page).to have_content 'somelargetext'  
      expect(page).to have_content '12,00'  
      expect(page).to have_content 'Porção editada com sucesso'
      expect(page).to have_content 'Nenhuma imagem cadastrada'
    end    

    it 'e cancela' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      within '#Portions' do
        click_on 'Meia Lasanha'
      end
      click_on 'Editar'
      click_on 'Cancelar'

      expect(current_path).to eq establishment_item_path(establishment, dish)
    end
    
    it 'e vê mensagens de erro' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      within '#Portions' do
        click_on 'Meia Lasanha'
      end
      click_on 'Editar'
      fill_in 'Nome',	with: '' 
      fill_in 'Descrição',	with: '' 
      fill_in 'Preço',	with: ''
      click_on 'Salvar Porção'

      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Descrição não pode ficar em branco'  
      expect(page).to have_content 'Preço não é um número'
      expect(page).to have_content 'Falha ao editar a porção'
    end

    it 'e não pode editar porção de outro estabelecimento' do
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
      establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user1, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: "Teste", full_address: "Av teste, 123", user: user2, 
                                            cnpj: CNPJ.generate, email: 'teste123@email.com', phone_number: '99999043113')
      dish1 = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment1)
      dish2 = Item.create!(name: 'Camarão', description: 'Camarão fresco, o ápice dos frutos do mar', calories: '250', item_type: 'dish', establishment: establishment2)
      portion1 = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish1)
      portion2 = Portion.create!(name: 'Petisco de Camarão', description: 'Pequenos camarões frescos como entrada, serve 2 pessoas', price: 19.99, item: dish2)

      login_as user1
      visit edit_establishment_item_portion_path(establishment2, dish2, portion2)
      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não possui acesso a essa página'    
    end
  end
  
  context 'pela página de bebidas' do
    it 'e visualiza botões' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      within '#Portions' do
        click_on 'Água 250 ml'
      end
      click_on 'Editar'

      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Preço'
      expect(page).to have_content 'Editar Porção de uma Bebida'
      expect(page).to have_field 'Escolher Imagem'
      expect(page).to have_button 'Salvar Porção'
    end
    
    it 'com sucesso' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      within '#Portions' do
        click_on 'Água 250 ml'
      end
      click_on 'Editar'
      fill_in 'Nome',	with: 'sometext' 
      fill_in 'Descrição',	with: 'somelargetext' 
      fill_in 'Preço',	with: '12.00'
      click_on 'Salvar Porção'

      expect(current_path).to eq establishment_item_portion_path(establishment, beverage, portion)
      expect(page).to have_content 'sometext'
      expect(page).to have_content 'somelargetext'  
      expect(page).to have_content '12,00'  
      expect(page).to have_content 'Porção editada com sucesso'
      expect(page).to have_content 'Nenhuma imagem cadastrada'
    end
    
    it 'e cancela' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      within '#Portions' do
        click_on 'Água 250 ml'
      end
      click_on 'Editar'
      click_on 'Cancelar'

      expect(current_path).to eq establishment_beverage_path(establishment, beverage)
    end
    
    it 'e vê mensagens de erro' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      within '#Portions' do
        click_on 'Água 250 ml'
      end
      click_on 'Editar'
      fill_in 'Nome',	with: '' 
      fill_in 'Descrição',	with: '' 
      fill_in 'Preço',	with: ''
      click_on 'Salvar Porção'

      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Descrição não pode ficar em branco'  
      expect(page).to have_content 'Preço não é um número'
      expect(page).to have_content 'Falha ao editar a porção'
    end

    it 'e não pode editar porções de outros estabelecimentos' do
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
      establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user1, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: "Teste", full_address: "Av teste, 123", user: user2, 
                                            cnpj: CNPJ.generate, email: 'teste123@email.com', phone_number: '99999043113')
      beverage1 = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment1, alcoholic: false)
      beverage2 = Beverage.create!(name: 'Cerveja', description: 'A melhor alcoólica de todas', calories: '100', item_type: 'beverage', establishment: establishment2, alcoholic: true)
      portion1 = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage1)
      portion2 = Portion.create!(name: 'Cerveja 300ml', description: 'Cerveja em garrafa de vidro de 300ml', price: 7.50, item: beverage2)

      login_as user1
      visit edit_establishment_item_portion_path(establishment2, beverage2, portion2)
      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não possui acesso a essa página' 
    end
  end
end
