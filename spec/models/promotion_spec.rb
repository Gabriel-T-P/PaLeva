require 'rails_helper'

RSpec.describe Promotion, type: :model do
  describe '#valid?' do
    context 'quando Nome' do
      it 'estiver ausente' do
        promotion = Promotion.new(name: '', percentage: 0.75, use_limit: 20, start_date: Date.current, end_date: 1.day.from_now.to_date)

        result = promotion.valid?

        expect(result).to be false  
      end
      
    end
    
    context 'quando Porcentagem' do
      it 'estiver ausente' do
        promotion = Promotion.new(name: 'Teste01', percentage: '', use_limit: 20, start_date: Date.current, end_date: 1.day.from_now.to_date)
        
        result = promotion.valid?

        expect(result).to be false  
      end
      
    end
    
    context 'quando Limite de Uso' do
      it 'estiver ausente' do
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: '', start_date: Date.current, end_date: 1.day.from_now.to_date)
        
        result = promotion.valid?

        expect(result).to be true
      end
    end
    
    context 'quando Data de Início' do
      it 'estiver ausente' do
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: 20, start_date: '', end_date: 1.day.from_now.to_date)
        
        result = promotion.valid?

        expect(result).to be false
      end
    end
    
    context 'quando Data de Fim' do
      it 'estiver ausente' do
        promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: 20, start_date: Date.current, end_date: '')
        
        result = promotion.valid?

        expect(result).to be false
      end
    end
    
  end
  
  
end
