require 'rails_helper'

describe 'usuário cria promoção para uma porção' do
  it 'pela nav' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Promoções'
    end

    expect(current_path).to eq new_promotion_path
    expect(page).to have_content 'Criar uma nova promocão'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Porcentagem'
    expect(page).to have_field 'Data de Início'
    expect(page).to have_field 'Data de Fim'
    expect(page).to have_field 'Limite de Usos'
    expect(page).to have_button 'Salvar Promoção'  
    expect(page).to have_link 'Cancelar'
  end
  
  it 'e formulário para criar promoção mostra todas as porções do estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    establishment2 = Establishment.create!(corporate_name: 'Teste inc', trade_name: "Teste", full_address: "Av teste, 123", 
                                            cnpj: CNPJ.generate, email: 'teste123@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    beverage = Item.create!(name: 'Água', description: 'Água mineral', calories: '20', item_type: 'beverage', establishment: establishment, alcoholic: false)
    portion1 = Portion.create!(name: '200 ml', description: 'Água Mineral', price: 2.50, item: beverage)
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
    portion2 = Portion.create!(name: 'Meia Porção', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
    dish2 = Item.create!(name: 'Camarão', description: 'Camarão fresco, o ápice dos frutos do mar', calories: '250', item_type: 'dish', establishment: establishment2)
    portion3 = Portion.create!(name: 'Lanche Pequeno', description: 'Pequenos camarões frescos como entrada, serve 2 pessoas', price: 19.99, item: dish2)

    login_as user
    visit new_promotion_path

    expect(page).to have_content 'Lista de porções dos pratos'
    expect(page).to have_content 'Lista de porções das bebidas'
    expect(page).to have_content 'Água - 200 ml'
    expect(page).to have_content 'Lasanha - Meia Porção'
    expect(page).not_to have_content 'Camarão - Lanche Pequeno'
  end
  
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    visit new_promotion_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'    
  end
  
  it 'e usuário não é admin' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = Employee.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    login_as user
    visit new_promotion_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'   
  end
  
end
