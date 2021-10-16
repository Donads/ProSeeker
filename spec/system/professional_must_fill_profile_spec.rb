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
      birth_date = 30.years.ago.to_date
      professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)

      login_as professional, scope: :user
      visit root_path
      within 'form' do
        fill_in 'Nome Completo', with: 'Fulano de Tal'
        fill_in 'Nome Social', with: 'Ciclano da Silva'
        fill_in 'Descrição', with: 'Busco projetos desafiadores'
        fill_in 'Qualificação Profissional', with: 'Ensino Superior'
        fill_in 'Experiência Profissional', with: '6 anos trabalhando em projetos diversos'
        fill_in 'Data de Nascimento', with: birth_date
        attach_file 'professional_profile[profile_photo]', 'spec/fixtures/files/avatar_placeholder.png'
        click_button 'Criar Perfil Profissional'
      end

      expect(page).to have_content('Perfil cadastrado com sucesso!')
      expect(page).to have_content('Nome Completo: Fulano de Tal')
      expect(page).to have_content('Nome Social: Ciclano da Silva')
      expect(page).to have_content('Descrição: Busco projetos desafiadores')
      expect(page).to have_content('Qualificação Profissional: Ensino Superior')
      expect(page).to have_content('Experiência Profissional: 6 anos trabalhando em projetos diversos')
      expect(page).to have_content('Data de Nascimento:')
      expect(page).to have_content(I18n.l(birth_date))
      expect(page).to have_content("Logado como '#{professional.email}' (Profissional)")
      expect(page).to have_link('Sair', href: destroy_user_session_path)
      expect(page).to have_no_link('Entrar')
      expect(page).to have_no_link('Registrar')
      expect(current_path).to_not eq new_professional_profile_path
    end

    it 'gets redirected and fails to fill it due to validations' do
      birth_date = 10.days.from_now
      professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)

      login_as professional, scope: :user
      visit root_path
      within 'form' do
        fill_in 'Nome Completo', with: ''
        fill_in 'Nome Social', with: ''
        fill_in 'Descrição', with: ''
        fill_in 'Qualificação Profissional', with: ''
        fill_in 'Experiência Profissional', with: ''
        fill_in 'Data de Nascimento', with: birth_date
        click_button 'Criar Perfil Profissional'
      end

      expect(page).to have_content('Preencha seu perfil profissional')
      expect(page).to have_content('Foto de Perfil não pode ficar em branco')
      expect(page).to have_content('Nome Completo não pode ficar em branco')
      expect(page).to have_content('Nome Social não pode ficar em branco')
      expect(page).to have_content('Descrição não pode ficar em branco')
      expect(page).to have_content('Qualificação Profissional não pode ficar em branco')
      expect(page).to have_content('Experiência Profissional não pode ficar em branco')
      expect(page).to have_content('Data de Nascimento deve estar no passado')
      expect(page).to have_content("Logado como '#{professional.email}' (Profissional)")
      expect(page).to have_link('Sair', href: destroy_user_session_path)
      expect(page).to have_no_link('Entrar')
      expect(page).to have_no_link('Registrar')
      expect(current_path).to_not eq new_professional_profile_path
    end
  end

  context 'professional profile requires authentication' do
    it 'visitor must sign in as professional' do
      visit new_professional_profile_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_css('div', text: 'Acesso restrito a profissionais autenticados.')
      expect(page).to have_content('Entrar')
      expect(page).to have_content('Registrar')
      expect(page).to have_no_content('Logado como')
    end

    it 'user is signed out and then must sign in as professional' do
      user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)

      login_as user, scope: :user
      visit new_professional_profile_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_css('div', text: 'Acesso restrito a profissionais autenticados.')
      expect(page).to have_content('Entrar')
      expect(page).to have_content('Registrar')
      expect(page).to have_no_content('Logado como')
    end
  end
end
