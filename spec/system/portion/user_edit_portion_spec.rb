require 'rails_helper'

describe 'usuário edita porção' do
  context 'pela página de pratos' do
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

      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Preço'
      expect(page).to have_field 'Selecionar Imagem'
      expect(page).to have_field 'Salvar'
    end
    
  end
  
  
end
