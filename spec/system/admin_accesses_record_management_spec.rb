require 'rails_helper'

describe 'Admin accesses record management' do
  it 'successfully' do
    admin = User.create!(email: 'admin@admin.com.br', password: '123456', role: :user)
    admin.admin!

    login_as admin, scope: :user
    visit root_path
    click_link 'Gerenciar Cadastros'

    expect(current_path).to eq manage_records_path
    expect(page).to have_link('Áreas de Conhecimento', href: knowledge_fields_path)
  end

  context 'but is not an admin' do
    it 'and can not see the link in the navbar' do
      user = User.create!(email: 'admin@admin.com.br', password: '123456', role: :user)

      login_as user, scope: :user
      visit root_path

      expect(page).to have_no_content('Gerenciar Cadastros')
    end

    it 'and can not access the page' do
      user = User.create!(email: 'admin@admin.com.br', password: '123456', role: :user)

      login_as user, scope: :user
      visit manage_records_path

      expect(current_path).to eq root_path
      expect(page).to have_css('div', text: 'Acesso restrito a Administradores')
    end
  end
end
