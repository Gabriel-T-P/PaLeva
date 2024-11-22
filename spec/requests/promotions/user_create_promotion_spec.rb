require 'rails_helper'

describe 'usuário cria uma promoção' do
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
    promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: '', start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])

    post promotions_path, params: {
      promotion: {
        name: 'Teste',
        percentage: 20,
        start_date: Date.current,
        end_date: 1.week.from_now.to_date,
        portions: [portion]
      }
    }
    
    expect(response).to redirect_to new_user_session_path
    expect(Promotion.count).to eq 0
  end
  
  it 'e não é admin do estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                          cnpj: '42.182.510/0001-77', email: 'carlosjonas@email.com', phone_number: '99999043113')
    dish = Item.create!(name: 'Lasanha', description: 'Carne, macarrão e molho', calories: '340', item_type: 'dish', establishment: establishment)
    portion = Portion.create!(name: 'Meia Lasanha', description: 'Lasanha de carne para 1 pessoa', price: 7.50, item: dish)
    promotion = Promotion.new(name: 'Teste01', percentage: 0.5, use_limit: '', start_date: Date.current, end_date: 1.day.from_now.to_date, portions: [portion])
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
    user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)

    login_as user2
    post promotions_path, params: {
      promotion: {
        name: 'Teste',
        percentage: 20,
        start_date: Date.current,
        end_date: 1.week.from_now.to_date,
        portions: [portion]
      }
    }

    expect(response).to redirect_to root_path(locale: I18n.locale)
    expect(Promotion.count).to eq 0
  end
end
