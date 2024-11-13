require 'rails_helper'

describe 'usuário vê porção' do
  context 'através da página de pratos' do
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
  
      expect(current_path).to eq establishment_item_portion_path(establishment, dish, portion)
      expect(page).to have_content 'Meia Lasanha'
      expect(page).to have_content 'Lasanha de carne para 1 pessoa'
      expect(page).to have_content 'Preço: R$ 7,50'
      expect(page).to have_content 'Ativo'
      expect(page).to have_content 'Nenhuma imagem cadastrada'
    end

    it 'e não está logado - prato' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)

      visit establishment_item_portion_path(establishment, dish, portion)

      expect(current_path).to eq new_user_session_path  
    end    

    it 'e não vê porções de outros pratos' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish1 = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      dish2 = Item.create!(name: 'Camarão', description: 'Camarão fresco, o ápice dos frutos do mar', calories: '250', item_type: 'dish', establishment: establishment)
      portion1 = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish1)
      portion2 = Portion.create!(name: 'Petisco de Camarão', description: 'Pequenos camarões frescos como entrada, serve 2 pessoas', price: 19.99, item: dish2)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      within '#Portions' do
        click_on 'Meia Lasanha'
      end

      expect(page).to have_content 'Meia Lasanha'
      expect(page).to have_content 'Lasanha de carne para 1 pessoa'
      expect(page).to have_content 'Preço: R$ 7,50'
      expect(page).not_to have_content 'Petisco de Camarão'
      expect(page).not_to have_content 'Pequenos camarões frescos como entrada, serve 2 pessoas'
      expect(page).not_to have_content '19,99'
    end
    
    it 'e não vê porções de bebidas' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      beverage = Item.create!(name: 'Água', description: 'Água mineral', calories: '20', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion1 = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
      portion2 = Portion.create!(name: 'Água mineral 200ml', description: 'Água mineral em copo plástico de 200ml', price: 3.00, item: beverage)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      within '#Portions' do
        click_on 'Meia Lasanha'
      end

      expect(page).to have_content 'Meia Lasanha'
      expect(page).to have_content 'Lasanha de carne para 1 pessoa'
      expect(page).to have_content 'Preço: R$ 7,50'
      expect(page).not_to have_content 'Água mineral 200ml'
      expect(page).not_to have_content 'Água mineral em copo plástico de 200ml'
      expect(page).not_to have_content '3,00'
    end
    
    it 'e não vê porções de outros estabelecimentos' do
      establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: "Teste", full_address: "Av teste, 123", 
                                            cnpj: CNPJ.generate, email: 'teste123@email.com', phone_number: '99999043113')
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
      dish1 = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment1)
      dish2 = Item.create!(name: 'Camarão', description: 'Camarão fresco, o ápice dos frutos do mar', calories: '250', item_type: 'dish', establishment: establishment2)
      portion1 = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish1)
      portion2 = Portion.create!(name: 'Petisco de Camarão', description: 'Pequenos camarões frescos como entrada, serve 2 pessoas', price: 19.99, item: dish2)
  
      login_as user1
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      within '#Portions' do
        click_on 'Meia Lasanha'
      end

      expect(page).to have_content 'Meia Lasanha'
      expect(page).to have_content 'Lasanha de carne para 1 pessoa'
      expect(page).to have_content 'Preço: R$ 7,50'
      expect(page).not_to have_content 'Petisco de Camarão'
      expect(page).not_to have_content 'Pequenos camarões frescos como entrada, serve 2 pessoas'
      expect(page).not_to have_content '19,99'
    end
    
    it 'e não pode acessar porções de outros estabelecimentos' do
      establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: "Teste", full_address: "Av teste, 123", 
                                            cnpj: CNPJ.generate, email: 'teste123@email.com', phone_number: '99999043113')
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
      dish1 = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment1)
      dish2 = Item.create!(name: 'Camarão', description: 'Camarão fresco, o ápice dos frutos do mar', calories: '250', item_type: 'dish', establishment: establishment2)
      portion1 = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish1)
      portion2 = Portion.create!(name: 'Petisco de Camarão', description: 'Pequenos camarões frescos como entrada, serve 2 pessoas', price: 19.99, item: dish2)
  
      login_as user1
      visit establishment_item_portion_path(establishment2, dish2, portion2)
      
      expect(current_path).to eq root_path  
      expect(page).to have_content 'Você não possui acesso a essa página'
    end
  end
  
  context 'através da página de bebidas' do
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
  
      expect(current_path).to eq establishment_beverage_portion_path(establishment, beverage, portion)
      expect(page).to have_content 'Água 250 ml'
      expect(page).to have_content 'Água mineral em copo plástico de 250ml'
      expect(page).to have_content 'Preço: R$ 2,50'
      expect(page).to have_content 'Ativo'
      expect(page).to have_content 'Nenhuma imagem cadastrada'
    end

    it 'e não está logado - bebida' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage)

      visit establishment_beverage_portion_path(establishment, beverage, portion)

      expect(current_path).to eq new_user_session_path  
    end
  
    it 'e não vê porções de outras bebidas' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage1 = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment, alcoholic: false)
      beverage2 = Beverage.create!(name: 'Cerveja', description: 'A melhor alcoólica de todas', calories: '100', item_type: 'beverage', establishment: establishment, alcoholic: true)
      portion1 = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage1)
      portion2 = Portion.create!(name: 'Cerveja 300ml', description: 'Cerveja em garrafa de vidro de 300ml', price: 7.50, item: beverage2)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      within '#Portions' do
        click_on 'Água 250 ml'
      end
  
      expect(page).to have_content 'Água 250 ml'
      expect(page).to have_content 'Água mineral em copo plástico de 250ml'
      expect(page).to have_content 'Preço: R$ 2,50'
      expect(page).not_to have_content 'Cerveja 300ml'
      expect(page).not_to have_content 'Cerveja em garrafa de vidro de 300ml'  
      expect(page).not_to have_content '7,50'
    end

    it 'e não vê porções de pratos' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
      beverage = Item.create!(name: 'Água', description: 'Água mineral', calories: '20', item_type: 'beverage', establishment: establishment, alcoholic: false)
      portion1 = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
      portion2 = Portion.create!(name: 'Água mineral 200ml', description: 'Água mineral em copo plástico de 200ml', price: 3.00, item: beverage)
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      within '#Portions' do
        click_on 'Água mineral 200ml'
      end

      expect(page).not_to have_content 'Meia Lasanha'
      expect(page).not_to have_content 'Lasanha de carne para 1 pessoa'
      expect(page).not_to have_content 'Preço: R$ 7,50'
      expect(page).to have_content 'Água mineral 200ml'
      expect(page).to have_content 'Água mineral em copo plástico de 200ml'
      expect(page).to have_content '3,00'
    end

    it 'e não vê porções de outros estabelecimentos' do
      establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: "Teste", full_address: "Av teste, 123", 
                                            cnpj: CNPJ.generate, email: 'teste123@email.com', phone_number: '99999043113')
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
      beverage1 = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment1, alcoholic: false)
      beverage2 = Beverage.create!(name: 'Cerveja', description: 'A melhor alcoólica de todas', calories: '100', item_type: 'beverage', establishment: establishment2, alcoholic: true)
      portion1 = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage1)
      portion2 = Portion.create!(name: 'Cerveja 300ml', description: 'Cerveja em garrafa de vidro de 300ml', price: 7.50, item: beverage2)
  
      login_as user1
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Água'
      within '#Portions' do
        click_on 'Água 250 ml'
      end
  
      expect(page).to have_content 'Água 250 ml'
      expect(page).to have_content 'Água mineral em copo plástico de 250ml'
      expect(page).to have_content 'Preço: R$ 2,50'
      expect(page).not_to have_content 'Cerveja 300ml'
      expect(page).not_to have_content 'Cerveja em garrafa de vidro de 300ml'  
      expect(page).not_to have_content '7,50'
    end
    
    it 'e não pode acessar porções de outros estabelecimentos' do
      establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: "Teste", full_address: "Av teste, 123", 
                                            cnpj: CNPJ.generate, email: 'teste123@email.com', phone_number: '99999043113')
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
      beverage1 = Beverage.create!(name: 'Água', description: 'Água mineral', calories: '40', item_type: 'beverage', establishment: establishment1, alcoholic: false)
      beverage2 = Beverage.create!(name: 'Cerveja', description: 'A melhor alcoólica de todas', calories: '100', item_type: 'beverage', establishment: establishment2, alcoholic: true)
      portion1 = Portion.create!(name: 'Água 250 ml', description: 'Água mineral em copo plástico de 250ml', price: 2.50, item: beverage1)
      portion2 = Portion.create!(name: 'Cerveja 300ml', description: 'Cerveja em garrafa de vidro de 300ml', price: 7.50, item: beverage2)

      login_as user1
      visit establishment_beverage_portion_path(establishment2, beverage2, portion2)
      
      expect(current_path).to eq root_path  
      expect(page).to have_content 'Você não possui acesso a essa página'
    end
    
  end
end
