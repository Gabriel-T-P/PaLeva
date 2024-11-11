require 'rails_helper'

RSpec.describe Employee, type: :model do 

  describe '#valid?' do
    context 'quando Nome' do
      it 'estiver presente' do
        user = Employee.new(first_name: '', last_name: '', cpf: '', email: '', password: '')
  
        user.valid?
        result = user.errors.full_messages
  
        expect(result).not_to include 'Nome não pode ficar em branco'  
      end

      it 'estiver ausente' do
        user = Employee.new(first_name: '', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
  
        result = user.valid?
  
        expect(result).to be true
      end      
    end

    context 'quando Sobrenome' do
      it 'estiver presente' do
        user = Employee.new(first_name: '', last_name: '', cpf: '', email: '', password: '')
  
        user.valid?
        result = user.errors.full_messages
  
        expect(result).not_to include 'Sobrenome não pode ficar em branco' 
      end

      it 'estiver ausente' do
        user = Employee.new(first_name: 'Carlos', last_name: '', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        
        result = user.valid?

        expect(result).to be true
      end   
    end
    
    context 'quando E-mail' do
      it 'existir = true' do
        user = Employee.new(first_name: '', last_name: '', cpf: '', email: 'teste@email.com', password: '')
  
        user.valid?
        result = user.errors.full_messages
  
        expect(result).not_to include 'E-mail não pode ficar em branco' 
      end
      
      it 'faltar = false' do
        user = Employee.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: '', password: '1234567891011')
        
        result = user.valid?

        expect(result).to be false
      end

      it 'inválido = false' do
        user = Employee.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlos@jonascomhotmail', password: '1234567891011')
      
        result = user.valid?

        expect(result).to be false
      end
    end
    
    context 'quando senha' do
      it 'ficar em branco' do
        user = Employee.new(first_name: '', last_name: '', cpf: '', email: '', password: '')
  
        user.valid?
        result = user.errors.full_messages
  
        expect(result).not_to include 'Senha não pode ficar em branco' 
      end

      it 'válida = true' do
        user = Employee.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        
        result = user.valid?

        expect(result).to be true  
      end

      it 'menor que 8 caracteres = false' do
        user = Employee.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '12345')
        
        result = user.valid?

        expect(result).to be false
      end
    end
    
    context 'quando cpf' do
      it 'não ficar em branco' do
        user = Employee.new(first_name: '', last_name: '', cpf: CPF.generate, email: '', password: '')
  
        user.valid?
        result = user.errors.full_messages
  
        expect(result).not_to include 'CPF não pode ficar em branco' 
      end
      
      it 'válido = true' do
        user = Employee.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')
        
        result = user.valid?

        expect(result).to be true  
      end
      
      it 'inválido = false' do
        user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: '05513333333', email: 'carlosjonas@email.com', password: '1234567891011')
        
        result = user.valid?

        expect(result).to be false
      end

      it 'já existir = false' do
        Employee.create!(first_name: 'Juan', last_name: 'Jonas', cpf: '05513333325', email: 'juanjonas@email.com', password: '1234567891011')
        user = Employee.new(first_name: 'Carlos', last_name: 'Jonas', cpf: '05513333325', email: 'carlosjonas@email.com', password: '1234567891011')
        
        result = user.valid?

        expect(result).to be false
      end

      it 'já existir entre user e employee' do
        User.create!(first_name: 'Juan', last_name: 'Jonas', cpf: '05513333325', email: 'juanjonas@email.com', password: '1234567891011')
        user = Employee.new(first_name: 'Carlos', last_name: 'Jonas', cpf: '05513333325', email: 'carlosjonas@email.com', password: '1234567891011')
        
        result = user.valid?

        expect(result).to be false
      end
    end
    
  end
  
  describe '#set_default_role_and_status' do
    it 'adiciona employee quando criado pela 1ª vez' do
      user = Employee.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

      result = user.employee?

      expect(result).to be true  
    end
    
    it 'não adiciona employee caso seja definido role' do
      user = User.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin')

      result = user.employee?

      expect(result).to be false  
    end

    it 'adiciona status pre_registered' do
      user = Employee.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011')

      result = user.pre_registered?

      expect(result).to be true  
    end
    
    it 'e adiciona pre_registered caso seja definido outro status' do
      user = Employee.new(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', status: 'active')

      result = user.pre_registered?

      expect(result).to be true  
    end
  end
end
