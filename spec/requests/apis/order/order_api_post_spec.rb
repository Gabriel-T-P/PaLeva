require 'rails_helper'

describe 'POST  /api/v1/orders' do
  it 'com sucesso' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    order_params = { order: {
      name: 'Carlos', email: 'teste123@email.com',
      phone_number: '99999999', cpf: '05513333325'
    }}
    
    post api_v1_orders_path, params: order_params
  
    expect(response).to have_http_status 201  
    expect(response.content_type).to include 'application/json'
    json_response = JSON.parse(response.body)
    expect(json_response['email']).to eq 'teste123@email.com'
    expect(json_response['name']).to eq 'Carlos'
    expect(json_response['cpf']).to eq '05513333325'
    expect(json_response['phone_number']).to eq '99999999'
    expect(json_response['status']).to eq 'waiting_cook_confirmation'
    expect(json_response.keys).not_to include 'updated_at'  
    expect(json_response.keys).not_to include 'id'
    expect(json_response.keys).not_to include 'user_id'
  end
  
  it 'com erros se parâmetros incorretos' do
    order_params = { order: {
      name: 'Carlos'
    }}

    post api_v1_orders_path, params: order_params

    expect(response).to have_http_status 412
    expect(response.content_type).to include 'application/json'
    json_response = JSON.parse(response.body)
    expect(json_response['errors']).to include 'E-mail não pode ficar em branco'
    expect(json_response['errors']).to include 'Número de Telefone não pode ficar em branco'
  end
  
  it 'com erros se um erro interno ocorre' do
    order = Order.new( name: 'Carlos', email: 'teste123@email.com', phone_number: '99999999', cpf: '05513333325' )
    order_params = { order: {
      name: 'Carlos'
    }}
    allow(Order).to receive(:new).and_return(order)
    allow(order).to receive(:save).and_raise(ActiveRecord::ActiveRecordError)
    
    post api_v1_orders_path, params: order_params

    expect(response).to have_http_status 500
    expect(response.content_type).to include 'application/json'
    json_response = JSON.parse(response.body)
    expect(json_response['result']).to eq 'Um erro interno aconteceu'
  end
end
