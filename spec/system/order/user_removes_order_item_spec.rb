require 'rails_helper'

describe 'usuário remove item do pedido' do
  it 'pelo carrinho' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 1
    click_on 'Adicionar'

    within '#Cart' do
      expect(page).to have_button 'x'
    end  
  end
  
  it 'com sucesso' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)

    login_as user
    visit establishment_item_portion_path(establishment, dish, portion)
    fill_in 'Quantidade',	with: 1
    click_on 'Adicionar'
    within '#Cart' do
      click_on 'x'
    end

    expect(page).to have_content 'Item removido com sucesso'  
    expect(page).not_to have_content 'Pão de Queijo'  
    expect(page).not_to have_content 'R$ 1,50x 1'
  end
  
end
