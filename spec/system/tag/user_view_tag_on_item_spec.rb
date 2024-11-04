require 'rails_helper'

describe 'usuário vê tags' do
  context 'em pratos' do
    it 'pela página do prato' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
      tag = Tag.create!(name: 'Picante')
      ItemTag.create!(item: dish, tag: tag)

      login_as user
      visit root_path
      click_on 'Meu Estabelecimento'
      click_on 'Lasanha'

      expect(page).to have_content 'Picante'
    end
    
    it 'e vê várias tags' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho picante', calories: '340', item_type: 'dish', establishment: establishment)
      tag1 = Tag.create!(name: 'Picante')
      tag2 = Tag.create!(name: 'Teste1')
      tag3 = Tag.create!(name: 'Teste2')
      ItemTag.create!(item: dish, tag: tag1)
      ItemTag.create!(item: dish, tag: tag2)
      ItemTag.create!(item: dish, tag: tag3)

      login_as user
      visit establishment_item_path(establishment, dish)

      expect(current_path).to eq establishment_item_path(establishment, dish)
      expect(page).to have_content 'Picante'
      expect(page).to have_content 'Teste1'
      expect(page).to have_content 'Teste2'
    end
    
  end
  
end
