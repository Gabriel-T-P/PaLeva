require 'rails_helper'

describe 'usuário atualiza um marcador' do
  it 'e não está logado' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    tag = Tag.create!(name: 'Picante')

    patch tag_path(tag), params: {
      tag: {
        name: 'Água',
        description: 'Água Mineral'
      }
    }
    
    tag.reload
    expect(response).to redirect_to new_user_session_path
    expect(tag.name).to eq 'Picante'
    expect(tag.description).to eq nil   
  end
  
  it 'e não é admin do estabelecimento' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", cnpj: CNPJ.generate, 
                                          email: 'carlosjonas@email.com', phone_number: '99999043113')
    user1 = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', role: 'admin', establishment: establishment)
    user2 = Employee.create!(first_name: 'Teste', last_name: 'Teste', cpf: CPF.generate, email: 'teste123@email.com', password: '1234567891011', role: 'employee', establishment: establishment)
    tag = Tag.create!(name: 'Picante')

    login_as user2
    patch tag_path(tag), params: {
      tag: {
        name: 'Água',
        description: 'Água Mineral'
      }
    }

    tag.reload
    expect(response).to redirect_to root_path(locale: I18n.locale)
    expect(tag.name).to eq 'Picante'
    expect(tag.description).to eq nil
  end
end
