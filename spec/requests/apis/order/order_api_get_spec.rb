require 'rails_helper'

describe 'order API' do
  context 'GET /api/v1/order/:id' do
    it 'com sucesso' do
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABC123')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      allow(SecureRandom).to receive(:alphanumeric).and_return('abcd1234')
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3, observation: 'nada nada')

      get api_v1_order_path(order)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      establishment_code = json_response['establishment_code'] 
      order_response = json_response['order']
      portions_response = json_response['portions']
      expect(establishment_code).to eq 'ABC123'  
      expect(order_response['name']).to eq 'Carlos'
      expect(order_response['code']).to eq 'ABCD1234'
      expect(order_response['status']).to eq 'waiting_cook_confirmation'
      expect(order_response.keys).not_to include 'updated_at'
      expect(order_response.keys).not_to include 'id'
      expect(order_response.keys).not_to include 'user_id'
      expect(portions_response.first['quantity']).to eq 3
      expect(portions_response.first['observation']).to eq 'nada nada'
      expect(portions_response.first.keys).not_to include 'portion_id'
      expect(portions_response.first.keys).not_to include 'order_id'
      expect(portions_response.first.keys).not_to include 'created_at'
      expect(portions_response.first.keys).not_to include 'updated_at'
      expect(portions_response.first['portion']['name']).to include 'Pequeno'
      expect(portions_response.first['portion']['description']).to include 'Uma unidade pequena de pão de queijo'
      expect(portions_response.first['portion']['price']).to include '1.5'
    end
    
    it 'e falha com pedido não encontrado' do
      
      get api_v1_order_path(99999)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['result']).to eq 'Pedido não encontrado'
    end

    it 'falha se tiver um erro interno' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3, observation: 'nada nada')

      allow(Order).to receive(:find).and_raise(ActiveRecord::ActiveRecordError)
      get api_v1_order_path(order)

      expect(response).to have_http_status 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)  
      expect(json_response['result']).to eq 'Um erro interno aconteceu' 
    end
  end
  
  context 'GET /api/v1/orders' do
    it 'com sucesso e retorna todos os pedidos' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order1 = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      order2 = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      portion_order = PortionOrder.create!(portion: portion, order: order1, quantity: 3, observation: 'nada nada')

      get api_v1_orders_path()

      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response.first.keys).not_to include 'updated_at'  
      expect(json_response.first.keys).not_to include 'user_id'
    end
    
    it 'retorna Não existem pedidos cadastrados' do
      
      get api_v1_orders_path()
    
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['result']).to eq 'Não existem pedidos cadastrados'
    end

    it 'com sucesso e retorna somente pedidos com status da query' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order1 = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      order2 = Order.create!(email: 'canceled@email.com', user: user, cpf: '05513333325', name: 'Canceled', phone_number: 'Canceled')
      order2.update(status: 'canceled')
      portion_order = PortionOrder.create!(portion: portion, order: order1, quantity: 3, observation: 'nada nada')

      get api_v1_orders_path(status: 'canceled')

      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 1
      expect(json_response.first['email']).to eq 'canceled@email.com'
      expect(json_response.first['name']).to eq 'Canceled'
      expect(json_response.first['phone_number']).to eq 'Canceled'
      expect(json_response.first['status']).to eq 'canceled'
    end

    it 'retorna todos caso query status inválida' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order1 = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      order2 = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      portion_order = PortionOrder.create!(portion: portion, order: order1, quantity: 3, observation: 'nada nada')

      get api_v1_orders_path(status: 'ABABABABA')

      expect(response.status).to eq 200  
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
    end

    it 'falha se tiver um erro interno' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3, observation: 'nada nada')

      allow(Order).to receive(:all).and_raise(ActiveRecord::ActiveRecordError)
      get api_v1_orders_path()

      expect(response).to have_http_status 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)  
      expect(json_response['result']).to eq 'Um erro interno aconteceu' 
    end
  end
end
