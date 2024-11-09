require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid_cpf' do
    it 'caso cpf não esteja presente' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      order = Order.new(email: 'teste123@email.com', user: user)

      result = order.valid?

      expect(order.errors.full_messages).not_to include 'CPF não é válido'
    end
    
    it 'caso cpf seja inválido' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      order = Order.new(email: 'teste123@email.com', user: user, cpf: '1111111111')

      result = order.valid?

      expect(order.errors.full_messages).to include 'CPF não é válido'
    end
    
    it 'caso cpf seja válido' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      order = Order.new(email: 'teste123@email.com', user: user, cpf: CPF.generate)

      result = order.valid?

      expect(order.errors.full_messages).not_to include 'CPF não é válido'
    end
  end
  
  describe '#valid?' do
    context 'quando E-mail' do
      it 'estiver presente e Número de Telefone não' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        order = Order.new(email: 'teste123@email.com', user: user)

        result = order.valid?

        expect(result).to be true
      end
      
      it 'estiver ausente e Número de Telefone também' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        order = Order.new(user: user)

        result = order.valid?
        expect(result).to be false
      end
      
      it 'estiver inválido' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                                cnpj: CNPJ.generate, email: 'teste123@email.com', phone_number: '99999043113')
        order = Order.new(user: user, email: 'teste123@email')

        result = order.valid?
        expect(result).to be false
      end
    end

    it 'quando E-mail e Número de Telefone estão presentes' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                              cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
      order = Order.new(email: 'teste123@email.com', user: user, phone_number: '99999043113')

      result = order.valid?

      expect(result).to be true
    end
    
    context 'quando Número de Telefone' do
      it 'estiver presente e E-mail não' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        order = Order.new(user: user, phone_number: '99999043113')

        result = order.valid?

        expect(result).to be true
      end
      
      it 'estiver ausente e E-mail também' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        order = Order.new(user: user)

        result = order.valid?
        expect(result).to be false
      end
    end

    it 'quando user estiver ausente' do
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, 
                                                cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
        order = Order.new(email: 'teste13@email.com')

        result = order.valid?
        expect(result).to be false
    end
    
  end
end
