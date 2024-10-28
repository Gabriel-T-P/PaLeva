require 'rails_helper'

RSpec.describe User, type: :model do 

  describe '#valid?' do

    context 'quando Nome' do
      it 'existir = true' do
        # Arrange
        user = User.new(first_name: 'Carlos', last_name: '', cpf: '', email: '', password: '')
  
        # Act
        user.valid?
        result = user.errors.full_messages
  
        # Assert
        expect(result).not_to include 'Nome não pode ficar em branco'  
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

    context 'quando Sobrenome' do
      it 'existir = true' do
        # Arrange
        user = User.new(first_name: '', last_name: 'Teste', cpf: '', email: '', password: '')
  
        # Act
        user.valid?
        result = user.errors.full_messages
  
        # Assert
        expect(result).not_to include 'Sobrenome não pode ficar em branco' 
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
    
    context 'quando E-mail' do
      it 'existir = true' do
        # Arrange
        user = User.new(first_name: '', last_name: '', cpf: '', email: 'teste@email.com', password: '')
  
        # Act
        user.valid?
        result = user.errors.full_messages
  
        # Assert
        expect(result).not_to include 'E-mail não pode ficar em branco' 
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
      it 'não ficar em branco' do
        # Arrange
        user = User.new(first_name: '', last_name: '', cpf: '', email: '', password: 'Teste')
  
        # Act
        user.valid?
        result = user.errors.full_messages
  
        # Assert
        expect(result).not_to include 'Senha não pode ficar em branco' 
      end

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
      it 'não ficar em branco' do
        # Arrange
        user = User.new(first_name: '', last_name: '', cpf: CPF.generate, email: '', password: '')
  
        # Act
        user.valid?
        result = user.errors.full_messages
  
        # Assert
        expect(result).not_to include 'CPF não pode ficar em branco' 
      end
      
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
  
  describe '#set_default_role' do
    it 'adiciona admin quando criado pela 1ª vez' do
      # Arrange
      user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

      # Act
      result = user.admin?

      # Assert
      expect(result).to be true  
    end
    
    it 'não adiciona admin caso seja definido role' do
      # Arrange
      user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'user')

      # Act
      result = user.admin?

      # Assert
      expect(result).to be false  
    end
  end
  
end
