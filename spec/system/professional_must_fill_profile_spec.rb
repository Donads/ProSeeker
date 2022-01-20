require 'rails_helper'

describe 'Professional must fill profile' do
  context 'profile has not been filled' do
    it 'gets redirected when trying to access the homepage' do
      professional = create(:user, :professional)

      login_as professional, scope: :user
      visit root_path

      expect(current_path).to eq new_professional_profile_path
      expect(page).to have_css('div',
                               text: 'Profissionais devem preencher o perfil por completo antes de terem acesso às funcionalidades da plataforma.')
      expect(page).to have_content('Criar Perfil Profissional')
    end

    it 'gets redirected and fills it successfully' do
      birth_date = 30.years.ago.to_date
      professional = create(:user, :professional)
      create(:knowledge_field)

      login_as professional, scope: :user
      visit root_path
      within 'form' do
        fill_in 'Nome Completo', with: 'Fulano de Tal'
        fill_in 'Nome Social', with: 'Ciclano da Silva'
        fill_in 'Descrição', with: 'Busco projetos desafiadores'
        fill_in 'Qualificação Profissional', with: 'Ensino Superior'
        fill_in 'Experiência Profissional', with: '6 anos trabalhando em projetos diversos'
        select 'Desenvolvedor', from: 'Área de Conhecimento'
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
      professional = create(:user, :professional)

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

      expect(page).to have_content('Criar Perfil Profissional')
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
      user = create(:user)

      login_as user, scope: :user
      visit new_professional_profile_path

      expect(current_path).to eq new_user_session_path
      expect(page).to have_css('div', text: 'Acesso restrito a profissionais autenticados.')
      expect(page).to have_content('Entrar')
      expect(page).to have_content('Registrar')
      expect(page).to have_no_content('Logado como')
    end
  end

  context 'professional edits their profile' do
    it 'successfully' do
      professional = create(:user, :professional)
      create(:profile, user: professional)

      login_as professional, scope: :user
      visit root_path
      click_link 'Meu Perfil'
      click_link 'Editar'
      fill_in 'Descrição', with: 'Desenvolvedor experiente em busca de novos desafios'
      click_button 'Atualizar Perfil Profissional'

      expect(current_path).to eq professional_profile_path(professional.professional_profile)
      expect(page).to have_css('div', text: 'Perfil atualizado com sucesso!')
      expect(page).to have_content('Desenvolvedor experiente em busca de novos desafios')
    end

    it 'and fails due to invalid fields' do
      professional = create(:user, :professional)
      create(:profile, user: professional)

      login_as professional, scope: :user
      visit root_path
      click_link 'Meu Perfil'
      click_link 'Editar'
      within 'form' do
        fill_in 'Nome Completo', with: ''
        fill_in 'Nome Social', with: ''
        fill_in 'Descrição', with: ''
        fill_in 'Qualificação Profissional', with: ''
        fill_in 'Experiência Profissional', with: ''
        fill_in 'Data de Nascimento', with: ''
        click_button 'Atualizar Perfil Profissional'
      end

      expect(current_path).to eq professional_profile_path(professional.professional_profile)
      expect(page).to have_css('div', text: 'Nome Completo não pode ficar em branco')
      expect(page).to have_css('div', text: 'Nome Social não pode ficar em branco')
      expect(page).to have_css('div', text: 'Descrição não pode ficar em branco')
      expect(page).to have_css('div', text: 'Qualificação Profissional não pode ficar em branco')
      expect(page).to have_css('div', text: 'Experiência Profissional não pode ficar em branco')
      expect(page).to have_css('div', text: 'Data de Nascimento não pode ficar em branco')
    end

    it 'and fails due to not being their profile' do
      professional_1 = create(:user, :professional)
      create(:profile, user: professional_1)
      professional_2 = create(:user, :professional)
      create(:profile, :profile_2, user: professional_2)

      login_as professional_1, scope: :user
      visit edit_professional_profile_path(professional_2.professional_profile)

      expect(current_path).to eq professional_profile_path(professional_2.professional_profile)
      expect(page).to have_css('div', text: 'Somente o usuário pode atualizar o próprio perfil.')
    end
  end
end
