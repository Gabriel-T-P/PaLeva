require 'rails_helper'

describe 'usuário vê todos os funcionários' do
  it 'pela user sidebar' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = User.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)
    employee1 = Employee.create!(first_name: 'Leon', last_name: 'employee', cpf: CPF.generate, email: 'employee@email.com', password: '12345678', establishment: establishment)
    employee2 = Employee.create!(first_name: 'Karl', last_name: 'employee', cpf: CPF.generate, email: 'employee222@email.com', password: '12345678', establishment: establishment)
    employee2.active!

    login_as user
    visit root_path
    within '#UserSidebar' do
      click_on 'Funcionário'
    end

    expect(current_path).to eq employees_path 
    expect(page).to have_content 'Lista de Funcionários'
    within '#EmployeeList' do
      expect(page).not_to have_content 'Carlos'  
      expect(page).not_to have_content 'carlosjonas@email.com'
    end
    expect(page).to have_content 'Leon'
    expect(page).to have_content 'Karl'
    expect(page).to have_content 'employee@email.com'
    expect(page).to have_content 'Ativo'  
    expect(page).to have_content 'employee222@email.com'
    expect(page).to have_content 'Pré-Registrado'
  end
  
  it 'e usuário não está logado' do
    
    visit employees_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'    
  end
  
  it 'e não é admin' do
    establishment = Establishment.create!(corporate_name: 'Carlos LTDA', trade_name: "Carlo's Café", full_address: "Rio Branco, Deodoro", 
                                            cnpj: CNPJ.generate, email: 'carlosjonas@email.com', phone_number: '99999043113')
    user = Employee.create!(first_name: 'Carlos', last_name: 'Jonas', cpf: CPF.generate, email: 'carlosjonas@email.com', password: '1234567891011', establishment: establishment)

    login_as user
    visit employees_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa página'
  end
end
