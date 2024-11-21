require 'rails_helper'

describe 'usuário atualiza um pedido' do
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: 'Carlos Café', full_address: 'Rio Branco, Deodoro', 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(name: 'Teste01', email: 'teste123@email.com', cpf: '05513333325', user: user)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)
    
    patch order_path(order), params: {
      order: {
        email: 'agua@email.com'
      }
    }
    
    order.reload
    expect(response).to redirect_to new_user_session_path
    expect(order.email).to eq 'teste123@email.com'
  end

  it 'e não admin não pode atualizar pedido que não é o dono' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: 'Carlos Café', full_address: 'Rio Branco, Deodoro', 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    employee = Employee.create!(first_name: 'Rein', last_name: 'Jonas', cpf: CPF.generate, email: 'reinJonas@email.com', password: '1234567891011', establishment: establishment)
    dish = Item.create!(name: 'Pão de Queijo', description: 'Polvilho e queijo assado no forno', calories: '50', item_type: 'dish', establishment: establishment)
    menu = Menu.create!(name: 'teste', establishment: establishment)
    menu.items << [dish]
    portion = Portion.create!(name: 'Pequeno', description: 'Uma unidade pequena de pão de queijo', price: 1.50, item: dish)
    order = Order.create!(name: 'Teste01', email: 'teste123@email.com', cpf: '05829579073', user: user)
    order2 = Order.create!(name: 'Teste02', email: 'teste321@email.com', cpf: '01234133032', user: employee)
    portion_order = PortionOrder.create!(portion: portion, order: order, quantity: 3)

    login_as employee
    patch order_path(order), params: {
      order: {
        email: 'agua@email.com'
      }
    }

    order.reload
    expect(response).to redirect_to root_path(locale: I18n.locale)
    expect(order.email).to eq 'teste123@email.com' 
  end
  
  it 'e não encontra o pedido' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: 'Carlos Café', full_address: 'Rio Branco, Deodoro', 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    login_as user
    patch order_path(999), params: {
      order: {
        email: 'agua@email.com'
      }
    }

    expect(response).to redirect_to root_path(locale: I18n.locale)
  end
end
