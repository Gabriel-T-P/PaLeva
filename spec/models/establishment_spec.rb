require 'rails_helper'

RSpec.describe Establishment, type: :model do
  describe 'gera um código aleatório' do
    it 'ao criar um novo estabelecimento' do
      # Arrange
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      establishment = Establishment.create!(corporate_name: 'Carloss LTDA', trade_name: "Carlos's Cafe", full_address: '123 Main St', user: user, cnpj: '33.113.309/0001-47', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')

      # Act

      # Assert
      expect(establishment.code).not_to be_empty
      expect(establishment.code.length).to eq 6     
    end

    it 'único' do
      # Arrange
      user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
      user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDEF')
      establishment1 = Establishment.create!(corporate_name: 'Carloss LTDA', trade_name: "Carlos's Cafe", full_address: '123 Main St', user: user1, cnpj: '33.113.309/0001-47', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDEF')
      establishment2 = Establishment.new(corporate_name: 'Teste Inc', trade_name: "Teste Teste", full_address: '123 Teste Principal', user: user2, cnpj: '11.764.779/0001-38', 
                                            email: 'teste123@email.com', phone_number: '12345678910')

      # Act
      result = establishment2.valid?

      # Assert
      expect(result).to be false
    end
    

  end

  describe '#valid?' do
    context 'quando Razão Social' do
      it 'existir = true' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: 'Carloss LTDA', trade_name: '', full_address: '', cnpj: '', 
                                            email: '', phone_number: '')

        # Act
        establishment.valid?
        result = establishment.errors.full_messages

        # Assert
        expect(result).not_to include 'Razão Social não pode ficar em branco'
      end
      
      it 'faltar = false' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: '', trade_name: "Carlos's Cafe", full_address: "123 Main St", user: user, cnpj: '33.113.309/0001-47', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to be false 
      end
    end
    
    context 'quando Nome Fantasia' do
      it 'existir = true' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: '', trade_name: 'Test', full_address: '', cnpj: '', 
                                            email: '', phone_number: '')

        # Act
        establishment.valid?
        result = establishment.errors.full_messages

        # Assert
        expect(result).not_to include 'Nome Fantasia não pode ficar em branco' 
      end
      
      it 'faltar = false' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: 'Carloss LTDA', trade_name: '', full_address: '123 Main St', user: user, cnpj: '33.113.309/0001-47', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to be false
      end
    end
    
    context 'quando Endereço' do
      it 'existir = true' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: '', trade_name: '', full_address: 'Teste', cnpj: '', 
                                            email: '', phone_number: '')

        # Act
        establishment.valid?
        result = establishment.errors.full_messages

        # Assert
        expect(result).not_to include 'Endereço não pode ficar em branco'
      end
      
      it 'faltar = false' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: 'Carloss LTDA', trade_name: "Carlos's Cafe", full_address: '', user: user, cnpj: '33.113.309/0001-47', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to be false
      end
    end
    
    context 'quando User' do
      it 'existir = true' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: '', trade_name: '', full_address: '', user: user, cnpj: '', 
                                            email: '', phone_number: '')

        # Act
        establishment.valid?
        result = establishment.errors.full_messages

        # Assert
        expect(result).not_to include 'Usuário não pode ficar em branco'
      end
      
      it 'faltar = false' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: 'Carloss LTDA', trade_name: "Carlos's Cafe", full_address: '123 Main St', cnpj: '33.113.309/0001-47', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to be false
      end
    end
    
    context 'quando Número de Telefone' do
      it 'existir = true' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: '', trade_name: '', full_address: '', cnpj: '', 
                                            email: '', phone_number: 'Teste')

        # Act
        establishment.valid?
        result = establishment.errors.full_messages

        # Assert
        expect(result).not_to include 'Número de Telefone não pode ficar em branco'
      end
      
      it 'faltar = false' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: 'Carloss LTDA', trade_name: "Carlos's Cafe", full_address: '123 Main St', user: user, cnpj: '33.113.309/0001-47', 
                                              email: 'carlosjonas@email.com', phone_number: '')

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to be false
      end
    end
    
    context 'quando E-mail' do
      it 'existir = true' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: '', trade_name: '', full_address: '', cnpj: '', 
                                            email: 'teste@email.com', phone_number: '')

        # Act
        establishment.valid?
        result = establishment.errors.full_messages

        # Assert
        expect(result).not_to include 'E-mail não pode ficar em branco'
      end
      
      it 'faltar = false' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: 'Carloss LTDA', trade_name: "Carlos's Cafe", full_address: '123 Main St', user: user, cnpj: '33.113.309/0001-47', 
                                              email: '', phone_number: '99999043113')

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to be false
      end

      it 'inválido = false' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: 'Carloss LTDA', trade_name: "Carlos's Cafe", full_address: '123 Main St', user: user, cnpj: '33.113.309/0001-47', 
                                              email: 'carlosjonas@email', phone_number: '99999043113')

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to be false  
      end
      
      it 'não é único = false' do
        # Arrange
        user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
        establishment1 = Establishment.create!(corporate_name: 'Carloss LTDA', trade_name: "Carlos's Cafe", full_address: '123 Main St', user: user1, cnpj: '33.113.309/0001-47', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        establishment2 = Establishment.new(corporate_name: 'Teste Inc', trade_name: "Teste Teste", full_address: '123 Teste Principal', user: user2, cnpj: '44.415.132/0001-50', 
                                              email: 'carlosjonas@email.com', phone_number: '12345678910')
        # Act
        result = establishment2.valid?

        # Assert
        expect(result).to be false
      end
      
    end
    
    context 'quando CNPJ' do
      it 'existir = true' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: '', trade_name: '', full_address: '', cnpj: '33.113.309/0001-47', 
                                            email: '', phone_number: '')

        # Act
        establishment.valid?
        result = establishment.errors.full_messages

        # Assert
        expect(result).not_to include 'CNPJ não pode ficar em branco' 
      end
      
      it 'faltar = false' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: 'Carlos LTDA', trade_name: "Carlos's Cafe", full_address: "123 Main St", user: user, cnpj: '', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to be false 
      end

      it 'inválido = false' do
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.new(corporate_name: 'Carlos LTDA', trade_name: "Carlos's Cafe", full_address: "123 Main St", user: user, cnpj: '33.000.000/0000-00', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to be false 
      end
      
      it 'não for único = false' do
        # Arrange
        user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011')
        establishment1 = Establishment.create!(corporate_name: 'Carloss LTDA', trade_name: "Carlos's Cafe", full_address: '123 Main St', user: user1, cnpj: '33.113.309/0001-47', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        establishment2 = Establishment.new(corporate_name: 'Teste Inc', trade_name: "Teste Teste", full_address: '123 Teste Principal', user: user2, cnpj: '33.113.309/0001-47', 
                                              email: 'teste123@email.com', phone_number: '12345678910')

        # Act
        result = establishment2.valid?

        # Assert
        expect(result).to be false
      end
    end
  end
  
  
end
