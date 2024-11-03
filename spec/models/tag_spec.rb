require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe '#valid?' do
    it 'e nome está presente' do
      tag = Tag.new(name: 'Picante')

      result = tag.valid?

      expect(result).to be true  
    end
    
    it 'e nome esta ausente' do
      tag = Tag.new(description: 'picante para bebidas e pratos')

      result = tag.valid?

      expect(result).to be false
    end
    
  end
  
end
