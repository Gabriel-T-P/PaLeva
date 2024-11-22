require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid_cpf' do
    it 'caso cpf não esteja presente' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      order = Order.new(email: 'teste123@email.com', user: user)

      result = order.valid?

      expect(order.errors.full_messages).not_to include 'CPF não é válido'
    end
    
    it 'caso cpf seja inválido' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      order = Order.new(email: 'teste123@email.com', user: user, cpf: '1111111111')

      result = order.valid?

      expect(order.errors.full_messages).to include 'CPF não é válido'
    end
    
    it 'caso cpf seja válido' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      order = Order.new(email: 'teste123@email.com', user: user, cpf: CPF.generate)

      result = order.valid?

      expect(order.errors.full_messages).not_to include 'CPF não é válido'
    end
  end
  
  describe '#uses_promotions' do
    it 'Limite de Uso existe e é maior que zero' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      promotion = Promotion.create!(name: 'Semana do Pão de Queijo', percentage: 0.20, use_limit: 20, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])
      menu = Menu.create!(name: 'teste', establishment: establishment, items: [dish])
      
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: CPF.generate, promotions: [promotion])

      promotion.reload
      expect(promotion.use_limit).to eq 19  
    end
    
    it 'Limite de Uso não existe' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      promotion = Promotion.create!(name: 'Semana do Pão de Queijo', percentage: 0.20, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])
      menu = Menu.create!(name: 'teste', establishment: establishment, items: [dish])
      
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: CPF.generate, promotions: [promotion])

      promotion.reload
      expect(promotion.use_limit).to eq nil
    end
    
    it 'Limite de Uso é zero' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
      portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
      promotion = Promotion.create!(name: 'Semana do Pão de Queijo', percentage: 0.20, use_limit: 0, start_date: 1.week.ago.to_date, end_date: 1.week.from_now.to_date, portions: [portion])
      menu = Menu.create!(name: 'teste', establishment: establishment, items: [dish])
      
      order = Order.create!(email: 'teste123@email.com', user: user, cpf: CPF.generate, promotions: [promotion])

      promotion.reload
      expect(promotion.use_limit).to eq 0
    end
  end

  describe '#valid?' do
    context 'quando E-mail' do
      it 'estiver presente e Número de Telefone não' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        order = Order.new(email: 'teste123@email.com', user: user)

        result = order.valid?

        expect(result).to be true
      end
      
      it 'estiver ausente e Número de Telefone também' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        order = Order.new(user: user)

        result = order.valid?
        expect(result).to be false
      end
      
      it 'estiver inválido' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'teste123@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        order = Order.new(user: user, email: 'teste123@email')

        result = order.valid?
        expect(result).to be false
      end
    end

    it 'quando E-mail e Número de Telefone estão presentes' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      order = Order.new(email: 'teste123@email.com', user: user, phone_number: '99999043113')

      result = order.valid?

      expect(result).to be true
    end
    
    context 'quando Número de Telefone' do
      it 'estiver presente e E-mail não' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        order = Order.new(user: user, phone_number: '99999043113')

        result = order.valid?

        expect(result).to be true
      end
      
      it 'estiver ausente e E-mail também' do
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        order = Order.new(user: user)

        result = order.valid?
        expect(result).to be false
      end
    end

    it 'quando user estiver ausente' do
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      order = Order.new(email: 'teste13@email.com')

      result = order.valid?
      expect(result).to be false
    end
    
  end
end
