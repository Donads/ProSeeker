require 'rails_helper'

describe 'Visitor views homepage' do
  it 'successfully' do
    visit root_path

    expect(current_path).to eq root_path
    expect(page).to have_content('Página Inicial')
  end

  context 'without signing in' do
    it 'and can not view restricted links' do
      visit root_path

      expect(page).to have_link('Entrar', href: new_user_session_path)
      expect(page).to have_link('Registrar', href: new_user_registration_path)
      expect(page).to have_no_link('Projetos')
      expect(page).to have_no_link('Meus Projetos')
      expect(page).to have_no_link('Cadastrar Novo Projeto')
      expect(page).to have_no_link('Sair')
      expect(page).to have_no_content('Logado como')
    end

    it 'and can not access projects' do
      visit projects_path

      expect(current_path).to eq root_path
      expect(page).to have_css('div', text: 'Usuário não autenticado')
      expect(page).to have_link('Entrar', href: new_user_session_path)
      expect(page).to have_link('Registrar', href: new_user_registration_path)
    end
  end
end
