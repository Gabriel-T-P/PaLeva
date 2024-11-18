require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe '#initialize' do
    it 'inicializa o carrinho vazio' do
      session = {}
      cart = Cart.new(session)

      expect(cart.items).to eq({})
    end
  end

  describe '#add_item' do
    it 'adiciona o item ao carrinho vazio' do
      session = {}
      cart = Cart.new(session)
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user)
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

      cart.add_item(portion_order)
      
      expect(cart.items['1']).to eq({
        'portion_name' => 'Pequeno',
        'item_name' => 'Pão de Queijo',
        "observation"=>nil,
        'quantity' => 3,
        'price' => 1.50
      })
    end

    it 'adiciona o item ao carrinho com vários itens diferentes' do
      session = {}
      cart = Cart.new(session)
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion1 = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      portion2 = Portion.create!(name: 'Grande', description: 'Uma unidade pequena de pão de queijo', price: 3.50, item: dish)
      portion3 = Portion.create!(name: 'Médio', description: 'Uma unidade pequena de pão de queijo', price: 5.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user)
      portion_order1 = PortionOrder.create!(portion: portion1, order: order, quantity: 3)
      portion_order2 = PortionOrder.create!(portion: portion2, order: order, quantity: 2)
      portion_order3 = PortionOrder.create!(portion: portion3, order: order, quantity: 1)

      cart.add_item(portion_order1)
      cart.add_item(portion_order2)
      cart.add_item(portion_order3)
      
      expect(cart.items.length).to eq 3
    end

    it 'adciona item que já existe no carrinho' do
      session = {}
      cart = Cart.new(session)
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user)

      cart.add_item(PortionOrder.create!(portion: portion, order: order, quantity: 3))
      cart.add_item(PortionOrder.create!(portion: portion, order: order, quantity: 1))
      
      expect(cart.items.length).to eq 1  
      expect(cart.items['1']).to eq({
        'portion_name' => 'Pequeno',
        'item_name' => 'Pão de Queijo',
        "observation"=>nil,
        'quantity' => 4,
        'price' => 1.50
      })
    end
  end

  describe '#remove_item' do
    it 'remove um item do carrinho' do
      session = {}
      cart = Cart.new(session)
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user)
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3) 
      cart.add_item(portion_order)

      cart.remove_item(portion.id)

      expect(cart.items.length).to eq 0
    end
    
    it 'e tenta remover item que não existe' do
      session = {}
      cart = Cart.new(session)
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      other_portion = Portion.create!(name: 'Grande', description: 'Uma unidade grande de pão de queijo', price: 3.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user)
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3) 
      cart.add_item(portion_order)

      cart.remove_item(PortionOrder.create!(portion: other_portion, order: order, quantity: 3))

      expect(cart.items.length).to eq 1
    end
  end

  describe '#clear' do
    it 'limpa o carrinho de pedidos' do
      session = {}
      cart = Cart.new(session)
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      order = Order.create!(email: 'teste123@email.com', user: user)
      portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)
      cart.add_item(portion_order)

      cart.clear

      expect(cart.items.length).to eq 0  
    end
    
  end
end
