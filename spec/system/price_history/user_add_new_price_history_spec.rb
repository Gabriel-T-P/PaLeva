require 'rails_helper'

describe 'usuário cria um histórico' do
  it 'ao adicionar uma porção e seu preço' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
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
  
end
