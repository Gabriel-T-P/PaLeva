require 'rails_helper'

describe 'usuário adiciona uma porção para o pedido' do
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
    
    post portion_orders_path, params: {
      portion_order: {
        portion: portion,
        quantity: 1
      }
    }
    
    expect(response.status).to redirect_to new_user_session_path
  end
end