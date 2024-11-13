require 'rails_helper'

RSpec.describe PortionOrder, type: :model do
  describe '#valid?' do
    context 'quando Quantidade' do
      it 'estiver presente e é número' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(quantity: 1)

        portion_order.valid?

        expect(portion_order.errors.full_messages).not_to include 'Quantidade não é um número'
      end
      
      it 'estiver ausente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(order: order, portion: portion, observation: 'Sem alecrim')

        portion_order.valid?

        expect(portion_order.errors.full_messages).to include 'Quantidade não é um número'  
      end
      
      it 'não for um número' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(order: order, portion: portion, quantity: 'a', observation: 'Sem alecrim')

        portion_order.valid?

        expect(portion_order.errors.full_messages).to include 'Quantidade não é um número'  
      end
      
      it 'não for um número inteiro' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(order: order, portion: portion, quantity: 1.5, observation: 'Sem alecrim')

        portion_order.valid?

        expect(portion_order.errors.full_messages).to include 'Quantidade não é um número inteiro'
      end
    end
    
    context 'quando Observação' do
      it 'estiver presente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(order: order, portion: portion, quantity: 1, observation: 'Sem alecrim')

        result = portion_order.valid?

        expect(result).to be true
      end
      
      it 'estiver ausente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(order: order, portion: portion, quantity: 1)

        result = portion_order.valid?

        expect(result).to be true
      end
      
      it 'for muito pequeno' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(order: order, portion: portion, quantity: 1, observation: 'abcd')

        portion_order.valid?

        expect(portion_order.errors.full_messages).to include 'Observação possui 6 caracteres como mínimo permitido'
      end
      
      it 'passar do mínimo permitido' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(order: order, portion: portion, quantity: 1, observation: 'abcdef')

        portion_order.valid?

        expect(portion_order.errors.full_messages).not_to include 'Observação possui 6 caracteres como mínimo permitido'
      end
    end
    
    context 'quando Pedido' do
      it 'estiver ausente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(quantity: 1, portion: portion)

        portion_order.valid?

        expect(portion_order.errors.full_messages).to include 'Pedido é obrigatório(a)'
      end
      
      it 'estiver presente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(order: order)

        result = portion_order.valid?

        expect(result).to be false  
        expect(portion_order.errors.full_messages).not_to include 'Pedido é obrigatório'
      end
    end
    
    context 'quando Porção' do
      it 'estiver ausente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(quantity: 1, order: order)

        portion_order.valid?

        expect(portion_order.errors.full_messages).to include 'Porção é obrigatório(a)'
      end
      
      it 'estiver presente' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
        portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
        order = Order.create!(email: 'teste123@email.com', user: user)
        portion_order = PortionOrder.new(portion: portion)

        result = portion_order.valid?

        expect(result).to be false  
        expect(portion_order.errors.full_messages).not_to include 'Porção é obrigatório'
      end
    end
  end
end
