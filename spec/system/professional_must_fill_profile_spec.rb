require 'rails_helper'

describe 'Professional must fill profile' do
  context 'profile has not been filled' do
    it 'gets redirected when trying to access the homepage' do
      professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)

      login_as professional, scope: :user
      visit root_path

      expect(current_path).to eq new_professional_profile_path
      expect(page).to have_css('div',
                               text: 'Profissionais devem preencher o perfil por completo antes de terem acesso às funcionalidades da plataforma.')
      expect(page).to have_content('Preencha seu perfil profissional')
    end

    it 'gets redirected and fills it successfully' do
      professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)

      login_as professional, scope: :user
      visit root_path
      within 'form' do
        fill_in 'Nome Completo', with: 'Fulano de Tal'
        fill_in 'Nome Social', with: 'Ciclano'
        fill_in 'Descrição', with: 'Busco projetos desafiadores'
        fill_in 'Qualificação Profissional', with: 'Ensino Superior'
        fill_in 'Experiência Profissional', with: '6 anos trabalhando em projetos diversos'
        fill_in 'Data de Nascimento', with: '31/12/1990'
        click_button 'Criar Perfil Profissional'
      end

      expect(page).to have_content('Perfil cadastrado com sucesso!')
      expect(page).to have_content('Nome Completo: Fulano de Tal')
      expect(page).to have_content('Nome Social: Ciclano')
      expect(page).to have_content('Descrição: Busco projetos desafiadores')
      expect(page).to have_content('Qualificação Profissional: Ensino Superior')
      expect(page).to have_content('Experiência Profissional: 6 anos trabalhando em projetos diversos')
      expect(page).to have_content('Data de Nascimento: 31/12/1990')
      expect(page).to have_content("Logado como '#{professional.email}' (Profissional)")
      expect(page).to have_link('Sair')
      expect(page).not_to have_link('Entrar')
      expect(page).not_to have_link('Registrar')
      expect(current_path).not_to eq new_professional_profile_path
    end
  end

  context 'professional profile requires authentication' do
    it 'visitor must sign in as professional' do
      visit new_professional_profile_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_css('div', text: 'Acesso restrito a profissionais autenticados.')
      expect(page).to have_content('Entrar')
      expect(page).to have_content('Registrar')
      expect(page).not_to have_content('Logado como')
    end

    it 'user is signed out and then must sign in as professional' do
      user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)

      login_as user, scope: :user
      visit new_professional_profile_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_css('div', text: 'Acesso restrito a profissionais autenticados.')
      expect(page).to have_content('Entrar')
      expect(page).to have_content('Registrar')
      expect(page).not_to have_content('Logado como')
    end
  end
end
