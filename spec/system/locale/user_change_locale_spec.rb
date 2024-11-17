require 'rails_helper'

describe 'usuário troca idioma' do
  it 'pelo botão na nav' do
    
    visit root_path

    expect(page).to have_link 'English'  
    expect(page).to have_link 'Português Brasileiro'
  end
  
  it 'com sucesso' do
    
    visit root_path
    click_on 'English'
    expect(page).to have_content 'Welcome!'
    expect(page).to have_content 'To view more info, please login'
  end
end
