require 'rails_helper'

describe 'usuário vê porção' do
  it 'atráves da página do prato' do
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
  end
  
  it 'atráves da página da bebida' do
    
  end
end
