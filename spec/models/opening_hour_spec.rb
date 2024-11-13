require 'rails_helper'

RSpec.describe OpeningHour, type: :model do
  describe '#open_today?' do
    it 'quando horário não fechado' do
      # Arrange  
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      opening_hour = OpeningHour.create!(day_of_week: 1, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
    
      # Act
      result = opening_hour.open_today?

      # Assert
      expect(result).to be true
    end
    
    it 'quando horário fechado' do
      # Arrange  
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      opening_hour = OpeningHour.create!(day_of_week: 1, closed: true, establishment: establishment)
    
      # Act
      result = opening_hour.open_today?

      # Assert
      expect(result).to be false
    end
  end

  describe '#opening_time_before_closing_time' do
    it 'horário de abertura menor que o horário de encerramento' do
      # Arrange  
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      opening_hour = OpeningHour.new(day_of_week: 1, closed: true,opening_time:'10:00', closing_time: '20:00', establishment: establishment)

      # Act
      result = opening_hour.valid?

      # Assert
      expect(result).to be true  
    end
    
    it 'horário de abertura maior que o horário de encerramento' do
      # Arrange  
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      opening_hour = OpeningHour.new(day_of_week: 1, closed: true,opening_time:'22:00', closing_time: '20:00', establishment: establishment)

      # Act
      result = opening_hour.valid?

      # Assert
      expect(result).to be false
      expect(opening_hour.errors.full_messages).to include 'Horário de Abertura deve ser antes ho Horário de Fechamento' 
    end

    it 'horário de abertura diferente do horário de fechamento' do
      # Arrange  
      establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                            email: 'carlosjonas@email.com', phone_number: '99999043113')
      user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
      opening_hour = OpeningHour.new(day_of_week: 1, closed: true,opening_time:'20:00', closing_time: '20:00', establishment: establishment)

      # Act
      result = opening_hour.valid?

      # Assert
      expect(result).to be false
      expect(opening_hour.errors.full_messages).to include 'Horário de Abertura deve ser diferente de Horário de Fechamento' 
    end
  end
  
  describe '#valid?' do

    context 'quando dia da semana' do
      it 'tem valor entre 0 e 6' do
        # Arrange  
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        opening_hour0 = OpeningHour.new(day_of_week: 0, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
        opening_hour1 = OpeningHour.new(day_of_week: 1, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
        opening_hour2 = OpeningHour.new(day_of_week: 2, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
        opening_hour3 = OpeningHour.new(day_of_week: 3, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
        opening_hour4 = OpeningHour.new(day_of_week: 4, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
        opening_hour5 = OpeningHour.new(day_of_week: 5, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
        opening_hour6 = OpeningHour.new(day_of_week: 6, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
      
        # Act
        result0 = opening_hour0.valid?
        result1 = opening_hour1.valid?
        result2 = opening_hour2.valid?
        result3 = opening_hour3.valid?
        result4 = opening_hour4.valid?
        result5 = opening_hour5.valid?
        result6 = opening_hour6.valid?

        # Assert
        expect(result0).to be true
        expect(result1).to be true
        expect(result2).to be true
        expect(result3).to be true
        expect(result4).to be true
        expect(result5).to be true
        expect(result6).to be true
      end
      
      it 'não tem valor entre 0 e 6' do
        # Arrange  
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        opening_hour0 = OpeningHour.new(day_of_week: -1, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
        opening_hour1 = OpeningHour.new(day_of_week: 7, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
        opening_hour2 = OpeningHour.new(day_of_week: 25, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
      
        # Act
        result0 = opening_hour0.valid?
        result1 = opening_hour1.valid?
        result2 = opening_hour2.valid?

        # Assert
        expect(result0).to be false
        expect(result1).to be false
        expect(result2).to be false
      end
      
      it 'já existir um cadastro' do
        # Arrange
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        opening_hour1 = OpeningHour.create!(day_of_week: 0, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
        opening_hour2 = OpeningHour.new(day_of_week: 0, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)

        # Act
        result = opening_hour2.valid?

        # Assert
        expect(result).to be false  
      end
      
      it 'já existir cadastro de outro estabelecimento' do
        # Arrange
        establishment1 = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: 'Rio Branco, Deodoro', cnpj: CNPJ.generate, 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: 'Teste Establishment', full_address: 'Av Teste, 213', cnpj: CNPJ.generate, 
                                              email: 'teste1234@email.com', phone_number: '99999043113')
        user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment1)
        user2 = User.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', establishment: establishment2)
        opening_hour1 = OpeningHour.create!(day_of_week: 0, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment1)
        opening_hour2 = OpeningHour.new(day_of_week: 0, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment2)

        # Act
        result = opening_hour2.valid?

        # Assert
        expect(result).to be true
      end
      
      it 'já existir um cadastro e aparece mensagem personalizada' do
        # Arrange
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        opening_hour1 = OpeningHour.create!(day_of_week: 0, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)
        opening_hour2 = OpeningHour.new(day_of_week: 0, closed: false, opening_time: '10:00', closing_time: '20:00', establishment: establishment)

        # Act
        opening_hour2.valid?
        result = opening_hour2.errors.full_messages

        # Assert
        expect(result).to include 'Dia da Semana Dia da semana já cadastrado, por favor faça a edição do dia ao ínves de um novo cadastro'
      end
    end
    
    context 'quando horário de abertura' do
      it 'estiver presente' do
        # Arrange  
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        opening_hour = OpeningHour.new(opening_time: '10:00', establishment: establishment)

        # Act
        opening_hour.valid?
        result = opening_hour.errors.full_messages

        # Assert
        expect(result).not_to include 'Horário de Abertura não pode ficar em branco'  
      end
      
      it 'estiver ausente' do
        # Arrange  
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        opening_hour = OpeningHour.new(day_of_week: 1, closed: false, closing_time: '20:00', establishment: establishment)

        # Act
        opening_hour.valid?
        result = opening_hour.errors.full_messages

        # Assert
        expect(result).to include 'Horário de Abertura não pode ficar em branco'
      end
      
      it 'se fechado for true' do
        # Arrange  
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        opening_hour = OpeningHour.new(day_of_week: 1, closed: true, closing_time: '20:00', establishment: establishment)

        # Act
        opening_hour.valid?
        result = opening_hour.errors.full_messages

        # Assert
        expect(result).not_to include 'Horário de Abertura não pode ficar em branco'
      end
    end
    
    context 'quando horário de encerramento' do
      it 'estiver presente' do
        # Arrange  
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        opening_hour = OpeningHour.new(closing_time: '10:00', establishment: establishment)

        # Act
        opening_hour.valid?
        result = opening_hour.errors.full_messages

        # Assert
        expect(result).not_to include 'Horário de Fechamento não pode ficar em branco'  
      end
      
      it 'estiver ausente' do
        # Arrange  
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        opening_hour = OpeningHour.new(day_of_week: 1, closed: false, opening_time: '20:00', establishment: establishment)

        # Act
        opening_hour.valid?
        result = opening_hour.errors.full_messages

        # Assert
        expect(result).to include 'Horário de Fechamento não pode ficar em branco'
      end
      
      it 'se fechado for true' do
        # Arrange  
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        opening_hour = OpeningHour.new(day_of_week: 1, closed: true, opening_time: '20:00', establishment: establishment)

        # Act
        opening_hour.valid?
        result = opening_hour.errors.full_messages

        # Assert
        expect(result).not_to include 'Horário de Fechamento não pode ficar em branco'
      end
    end
    
    context 'quando fechado' do
      it 'for válido' do
        # Arrange  
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: '42.182.510/0001-77', 
                                              email: 'carlosjonas@email.com', phone_number: '99999043113')
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
        opening_hour = OpeningHour.new(day_of_week: 0, closed: true, opening_time: '10:00', closing_time: '20:00', establishment: establishment)

        # Act
        result = opening_hour.valid?

        # Assert
        expect(result).to be true  
      end
    end
    
  end
  
end