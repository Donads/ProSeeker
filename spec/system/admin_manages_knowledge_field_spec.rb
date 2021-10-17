require 'rails_helper'

describe 'Admin manages knowledge field' do
  it 'creates a new one successfully' do
    admin = User.create!(email: 'admin@admin.com.br', password: '123456', role: :user)
    admin.admin!

    login_as admin, scope: :user
    visit root_path
    click_link 'Gerenciar Cadastros'
    click_link 'Áreas de Conhecimento'
    click_link 'Novo'
    fill_in 'Título', with: 'Teste de Título'
    click_button 'Criar Área de Conhecimento'

    expect(current_path).to eq knowledge_fields_path
    expect(page).to have_css('div', text: 'Área de Conhecimento cadastrada com sucesso!')
    expect(page).to have_content('Áreas de Conhecimento')
    expect(page).to have_content('Teste de Título')
  end

  it 'and fails to create it due to missing fields' do
    admin = User.create!(email: 'admin@admin.com.br', password: '123456', role: :user)
    admin.admin!

    login_as admin, scope: :user
    visit root_path
    click_link 'Gerenciar Cadastros'
    click_link 'Áreas de Conhecimento'
    click_link 'Novo'
    fill_in 'Título', with: ''
    click_button 'Criar Área de Conhecimento'

    expect(page).to have_css('div', text: 'Título não pode ficar em branco')
    expect(page).to have_content('Cadastro de Áreas de Conhecimento')
    expect(page).to have_button('Criar Área de Conhecimento')
  end
end
