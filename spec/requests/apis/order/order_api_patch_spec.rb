require 'rails_helper'

describe 'order API' do
  context 'PATCH /api/v1/orders/:id/set_status_cooking' do
    it 'com sucesso' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3, observation: 'nada nada')

      patch set_status_cooking_api_v1_order_path(order)

      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eq 'teste123@email.com'
      expect(json_response['name']).to eq 'Carlos'
      expect(json_response['cpf']).to eq '05513333325'
      expect(json_response['phone_number']).to eq '99999999'
      expect(json_response['status']).to eq 'cooking'
      expect(json_response.keys).not_to include 'updated_at'  
      expect(json_response.keys).not_to include 'id'
      expect(json_response.keys).not_to include 'user_id'
    end
    
    it 'falha com pedido não encontrado' do
      
      patch set_status_cooking_api_v1_order_path(999999)

      expect(response).to have_http_status(404)
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

      allow(Order).to receive(:find).and_return(order)
      allow(order).to receive(:update).and_raise(ActiveRecord::ActiveRecordError)
      patch set_status_cooking_api_v1_order_path(order)

      expect(response).to have_http_status 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)  
      expect(json_response['result']).to eq 'Um erro interno aconteceu' 
    end
  end
  
  context 'PATCH /api/v1/orders/:id/set_status_ready' do
    it 'com sucesso' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3, observation: 'nada nada')

      patch set_status_ready_api_v1_order_path(order)

      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eq 'teste123@email.com'
      expect(json_response['name']).to eq 'Carlos'
      expect(json_response['cpf']).to eq '05513333325'
      expect(json_response['phone_number']).to eq '99999999'
      expect(json_response['status']).to eq 'ready'
      expect(json_response.keys).not_to include 'updated_at'
      expect(json_response.keys).not_to include 'id'
      expect(json_response.keys).not_to include 'user_id'
    end
    
    it 'falha com pedido não encontrado' do
      
      patch set_status_ready_api_v1_order_path(999999)

      expect(response).to have_http_status(404)
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

      allow(Order).to receive(:find).and_return(order)
      allow(order).to receive(:update).and_raise(ActiveRecord::ActiveRecordError)
      patch set_status_ready_api_v1_order_path(order)

      expect(response).to have_http_status 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)  
      expect(json_response['result']).to eq 'Um erro interno aconteceu' 
    end
  end

  context 'PATCH /api/v1/:establishment_code/:order_code/orders/:id/set_status_canceled' do
    it 'com sucesso' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3, observation: 'nada nada')

      patch set_status_canceled_api_v1_establishment_order_order_path(establishment.code, order.code, order)

      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eq 'teste123@email.com'
      expect(json_response['name']).to eq 'Carlos'
      expect(json_response['cpf']).to eq '05513333325'
      expect(json_response['phone_number']).to eq '99999999'
      expect(json_response['status']).to eq 'canceled'
      expect(json_response.keys).not_to include 'updated_at'
      expect(json_response.keys).not_to include 'id'
      expect(json_response.keys).not_to include 'user_id'
    end
    
    it 'e envia um motivo do cancelamento' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3, observation: 'nada nada')

      patch set_status_canceled_api_v1_establishment_order_order_path(establishment.code, order.code, order), params: {cancel_reason: 'nada a declarar'}

      expect(response).to have_http_status(200)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['cancel_reason']).to eq 'nada a declarar'
      expect(json_response['status']).to eq 'canceled'
    end
    
    it 'falha com pedido não encontrado' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      allow(SecureRandom).to receive(:alphanumeric).and_return('BBBBBBBB')
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3, observation: 'nada nada')

      patch set_status_canceled_api_v1_establishment_order_order_path(establishment.code, 'AAAAAAAA', order)

      expect(response).to have_http_status 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['result']).to eq 'Pedido não encontrado'  
    end
    
    it 'e falha com um erro interno' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: '05513333325', name: 'Carlos', phone_number: '99999999')
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3, observation: 'nada nada')

      allow(Order).to receive(:find_by!).and_return(order)
      allow(order).to receive(:update).and_raise(ActiveRecord::ActiveRecordError)
      patch set_status_canceled_api_v1_establishment_order_order_path(establishment.code, order.code, order)

      expect(response).to have_http_status 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['result']).to eq 'Um erro interno aconteceu'    
    end
    
  end
end
