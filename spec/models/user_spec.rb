require 'rails_helper'

RSpec.describe User, type: :model do 

  describe '#valid?' do

    context 'quando first_name' do
      it 'existir = true' do
        # Arrange
        user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
  
        # Act
        result = user.valid?
  
        # Assert
        expect(result).to be true
  
      end

      it 'faltar = false' do
        # Arrange
        user = User.new(first_name: '', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
  
        # Act
        result = user.valid?
  
        # Assert
        expect(result).to be false
      end      
    end

    context 'quando last_name' do
      it 'existir = true' do
        # Arrange
        user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        
        # Act
        result = user.valid?

        # Assert
        expect(result).to be true  
      end

      it 'faltar = false' do
        # Arrange
        user = User.new(first_name: 'Carlos', last_name: '', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        
        # Act
        result = user.valid?

        # Assert
        expect(result).to be false
      end   
    end
    
    context 'quando email' do
      it 'existir = true' do
        # Arrange
        user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        
        # Act
        result = user.valid?

        # Assert
        expect(result).to be true
      end
      
      it 'faltar = false' do
        # Arrange
        user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: '', password: '1234567891011')
        
        # Act
        result = user.valid?

        # Assert
        expect(result).to be false
      end

      it 'inválido = false' do
        # Arrange
        user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlos@jonascomhotmail', password: '1234567891011')
      
        # Act
        result = user.valid?

        # Assert
        expect(result).to be false
      end
    end
    
    context 'quando senha' do
      it 'válida = true' do
        # Arrange
        user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        
        # Act
        result = user.valid?

        # Assert
        expect(result).to be true  
      end

      it 'menor que 8 caracteres = false' do
        # Arrange
        user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '12345')
        
        # Act
        result = user.valid?

        # Assert
        expect(result).to be false
      end
    end
    
    context 'quando cpf' do
      it 'válido = true' do
        # Arrange
        user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        
        # Act
        result = user.valid?

        # Assert
        expect(result).to be true  
      end
      
      it 'inválido = false' do
        # Arrange
        user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: '05513333333', email: 'carlosjonas@email.com', password: '1234567891011')
        
        # Act
        result = user.valid?

        # Assert
        expect(result).to be false
      end

      it 'já existir = false' do
        # Arrange
        User.create!(first_name: 'Juan', last_name: 'Jonas', cpf: '05513333325', email: 'juanjonas@email.com', password: '1234567891011')
        user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: '05513333325', email: 'carlosjonas@email.com', password: '1234567891011')
        
        # Act
        result = user.valid?

        # Assert
        expect(result).to be false
      end
    end   
    
  end
  

end
