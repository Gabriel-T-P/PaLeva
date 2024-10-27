require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '#valid?' do
    context 'quando Alcoólico' do
      it 'for válido' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        beverage = Beverage.new(name: 'Cerveja', description: 'A bebida mais comum do Brasil', calories: '140', establishment: establishment, alcoholic: true, item_type: :beverage)

        # Act
        result = beverage.valid?

        # Assert
        expect(result).to be true
      end

      it 'for inválido' do
        # Arrange
        user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", user: user, cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
        beverage = Beverage.new(name: 'Cerveja', description: 'A bebida mais comum do Brasil', calories: '140', establishment: establishment, item_type: :beverage)

        # Act
        result = beverage.valid?

        # Assert
        expect(result).to be false
      end 
    end
  end
end
