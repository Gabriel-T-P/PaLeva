require 'rails_helper'

describe 'usuário cria um pedido' do
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    
    post orders_path, params: {
      order: {
        email: 'Água'
      }
    }
    
    expect(response).to redirect_to new_user_session_path
  end
end
