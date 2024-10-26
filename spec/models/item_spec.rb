require 'rails_helper'

RSpec.describe Item, type: :model do

  describe '#valid?' do

    context 'quando Nome' do
      it 'está presente' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.new(name: 'Lasanha', description: '', calories: '', item_type: '', establishment: establishment)

        # Act
        dish.valid?
        result = dish.errors.full_messages

        # Assert
        expect(result).not_to include 'Nome não pode ficar em branco'  
      end
      
      it 'está faltando' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.new(name: '', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)

        # Act
        result = dish.valid?

        # Assert
        expect(result).to be false
      end

      it 'já existe' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        other_dish = Item.create!(name: 'Lasanha', description: 'Alma do macarrão', calories: '400', item_type: 'dish', establishment: establishment)
        dish = Item.new(name: 'Lasanha', description: 'A melhor lasanha', calories: '350', item_type: 'dish', establishment: establishment)

        # Act
        result = dish.valid?

        # Assert
        expect(result).to be false
      end
      
    end
    
    context 'quando Descrição' do
      it 'está presente' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.new(name: '', description: 'Testando123', calories: '', item_type: '', establishment: establishment)

        # Act
        dish.valid?
        result = dish.errors.full_messages

        # Assert
        expect(result).not_to include 'Descrição não pode ficar em branco'
      end
      
      it 'está faltando' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.new(name: 'Lasanha', description: '', calories: '400', item_type: 'dish', establishment: establishment)

        # Act
        result = dish.valid?

        # Assert
        expect(result).to be false
      end
    end
    
    context 'quando Calorias' do
      it 'está presente' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.new(name: '', description: '', calories: '400', item_type: '', establishment: establishment)

        # Act
        dish.valid?
        result = dish.errors.full_messages

        # Assert
        expect(result).not_to include 'Calorias não pode ficar em branco'
      end
      
      it 'está faltando' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.new(name: 'Lasanha', description: 'A alma do macarrão', calories: '', item_type: 'dish', establishment: establishment)

        # Act
        result = dish.valid?

        # Assert
        expect(result).to be false
      end

      it 'não é numérico' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.new(name: 'Lasanha', description: 'A alma do macarrão', calories: 'teste', item_type: 'dish', establishment: establishment)

        # Act
        result = dish.valid?
        
        # Assert
        expect(result).to be false
        expect(dish.errors.full_messages).to include 'Calorias não é um número'    
      end
      
    end

    context 'quando Tipo' do
      it 'está presente' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.new(name: '', description: '', calories: '', item_type: 'dish', establishment: establishment)

        # Act
        dish.valid?
        result = dish.errors.full_messages

        # Assert
        expect(result).not_to include 'Tipo não pode ficar em branco'
      end
      
      it 'está faltando' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        dish = Item.new(name: 'Lasanha', description: 'A alma do macarrão', calories: '400', establishment: establishment)

        # Act
        result = dish.valid?

        # Assert
        expect(result).to be false
        expect(dish.errors.full_messages).to include 'Tipo não pode ficar em branco'
      end  
    end
    
  end

end
