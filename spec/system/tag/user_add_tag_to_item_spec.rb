require 'rails_helper'

describe 'usuário adiciona tag' do
  context 'ao prato ' do
    it 'na página do prato' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
      tag = Tag.create!(name: 'Picante', description: 'moderadamente picante para pratos e talvez bebidas')
  
      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'
      click_on 'Adicionar Marcador'
  
      expect(page).to have_content 'Selecione um Marcador'
      expect(page).to have_button 'Picante'
    end
    
    it 'e vê várias tags' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
      tag = Tag.create!(name: 'Picante')
      tag = Tag.create!(name: 'Vegano')
      tag = Tag.create!(name: 'Zero Áçúcar')

      login_as user
      visit establishment_item_path(establishment, dish)
      click_on 'Adicionar Marcador'

      expect(page).to have_content 'Picante'
      expect(page).to have_content 'Vegano'
      expect(page).to have_content 'Zero Áçúcar'
    end

    it 'com sucesso' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
      tag = Tag.create!(name: 'Picante')

      login_as user
      visit establishment_item_path(establishment, dish)
      click_on 'Adicionar Marcador'
      click_on 'Picante'

      expect(current_path).to eq establishment_item_path(establishment, dish)
      expect(page).to have_content 'Marcador adicionado'
      within '#Tags' do
        expect(page).to have_content 'Picante'
      end  
    end
    
    it 'e adiciciona tag que o prato já tinha antes' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
      tag = Tag.create!(name: 'Picante')
      ItemTag.create!(item: dish, tag: tag)

      login_as user
      visit establishment_item_path(establishment, dish)
      click_on 'Adicionar Marcador'
      within '#tagModal' do
        click_on 'Picante'
      end

      expect(current_path).to eq establishment_item_path(establishment, dish)
      expect(page).to have_content 'Esse prato já possui esse marcador'
    end

    it 'e tag não é exclusiva de um prato' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish1 = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
      dish2 = Item.create!(name: 'Macarronada', description: 'Carne moída, macarrão e molho picante', calories: '320', item_type: 'dish', establishment: establishment)
      tag = Tag.create!(name: 'Picante')
      ItemTag.create!(item: dish1, tag: tag)

      login_as user
      visit establishment_item_path(establishment, dish2)
      click_on 'Adicionar Marcador'
      click_on 'Picante'

      expect(page).to have_content 'Marcador adicionado'
      expect(page).to have_content 'Picante' 
    end
  end
  
  context 'à bebida' do
    it 'na página da bebida' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
      tag = Tag.create!(name: 'Refrescante', description: 'bebida refrescante')

      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Limonada'
      click_on 'Adicionar Marcador'
  
      expect(page).to have_content 'Selecione um Marcador'
      expect(page).to have_button 'Refrescante'
    end
    
    it 'e vê várias tags' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
      Tag.create!(name: 'Refrescante')
      Tag.create!(name: '100% Natural')
      Tag.create!(name: 'Cítrico')

      login_as user
      visit establishment_beverage_path(establishment, beverage)
      click_on 'Adicionar Marcador'

      expect(page).to have_content 'Refrescante'
      expect(page).to have_content '100% Natural'
      expect(page).to have_content 'Cítrico'
    end
    
    it 'com sucesso' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
      tag = Tag.create!(name: 'Refrescante')

      login_as user
      visit establishment_beverage_path(establishment, beverage)
      click_on 'Adicionar Marcador'
      click_on 'Refrescante'

      expect(current_path).to eq establishment_beverage_path(establishment, beverage)
      expect(page).to have_content 'Marcador adicionado'
      within '#Tags' do
        expect(page).to have_content 'Refrescante'
      end 
    end
    
    it 'e adiciciona tag que a bebida já tinha antes' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
      tag = Tag.create!(name: 'Refrescante')
      ItemTag.create!(item: beverage, tag: tag)

      login_as user
      visit establishment_beverage_path(establishment, beverage)
      click_on 'Adicionar Marcador'
      within '#tagModal' do
        click_on 'Refrescante'
      end

      expect(page).to have_content 'Essa bebida já possui esse marcador'
    end
    
    it 'e tag não é exclusiva de uma bebida' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      beverage1 = Beverage.create!(name: 'Limonada', description: 'Limão não Siciliano, expremido com gelo e açúcar', calories: '40', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
      beverage2 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco de laranja dos bons', calories: '30', item_type: 'beverage',
                                  establishment: establishment, alcoholic: false)
      tag = Tag.create!(name: 'Refrescante')
      ItemTag.create!(item: beverage1, tag: tag)

      login_as user
      visit establishment_beverage_path(establishment, beverage2)
      click_on 'Adicionar Marcador'
      click_on 'Refrescante'

      expect(page).to have_content 'Marcador adicionado'
      expect(page).to have_content 'Refrescante'  
    end
  end
end
