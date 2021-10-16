require 'rails_helper'

describe 'Visitor signs in' do
  context 'as an user' do
    it 'successfully' do
      user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)

      visit root_path
      click_link 'Entrar'
      within 'form' do
        fill_in 'E-mail', with: user.email
        fill_in 'Senha', with: user.password
        click_button 'Entrar'
      end

      expect(page).to have_content('Login efetuado com sucesso!')
      expect(page).to have_content("Logado como '#{user.email}' (Usuário)")
      expect(page).to have_link('Sair')
      expect(page).not_to have_link('Entrar')
      expect(page).not_to have_link('Registrar')
    end

    it 'and logs out' do
      user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)

      login_as user, scope: :user
      visit root_path
      click_link 'Sair'

      expect(current_path).to eq root_path
      expect(page).to have_content('Saiu com sucesso')
      expect(page).to have_link('Entrar')
      expect(page).to have_link('Registrar')
      expect(page).not_to have_content(user.email)
      expect(page).not_to have_link('Sair')
    end
  end

  context 'as a professional' do
    it 'successfully and has filled their profile' do
      professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
      photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
      profile = ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                            description: 'Busco projetos desafiadores',
                                            professional_qualification: 'Ensino Superior',
                                            professional_experience: '6 anos trabalhando em projetos diversos',
                                            birth_date: '1990-12-31', user: professional, profile_photo: photo)

      visit root_path
      click_link 'Entrar'
      within 'form' do
        fill_in 'E-mail', with: professional.email
        fill_in 'Senha', with: professional.password
        click_button 'Entrar'
      end

      expect(page).to have_content('Login efetuado com sucesso!')
      expect(page).to have_content("Logado como '#{professional.email}' (Profissional)")
      expect(page).to have_link('Sair')
      expect(page).not_to have_link('Entrar')
      expect(page).not_to have_link('Registrar')
    end

    it 'successfully and has not filled their profile' do
      professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)

      visit root_path
      click_link 'Entrar'
      within 'form' do
        fill_in 'E-mail', with: professional.email
        fill_in 'Senha', with: professional.password
        click_button 'Entrar'
      end

      expect(current_path).to eq new_professional_profile_path
      expect(page).to have_css('div',
                               text: 'Profissionais devem preencher o perfil por completo antes de terem acesso às funcionalidades da plataforma.')
      expect(page).to have_content("Logado como '#{professional.email}' (Profissional)")
      expect(page).to have_link('Sair')
      expect(page).not_to have_link('Entrar')
      expect(page).not_to have_link('Registrar')
    end

    it 'and logs out' do
      professional = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :professional)

      login_as professional, scope: :user
      visit root_path
      click_link 'Sair'

      expect(current_path).to eq root_path
      expect(page).to have_content('Saiu com sucesso')
      expect(page).to have_link('Entrar')
      expect(page).to have_link('Registrar')
      expect(page).not_to have_content(professional.email)
      expect(page).not_to have_link('Sair')
    end
  end

  it 'with invalid credentials' do
    invalid_user = { email: 'usuario@teste.com.br', password: '123456' }

    visit root_path
    click_link 'Entrar'
    within 'form' do
      fill_in 'E-mail', with: invalid_user[:email]
      fill_in 'Senha', with: invalid_user[:password]
      click_button 'Entrar'
    end

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('E-mail ou senha inválida')
    expect(page).to have_link('Entrar')
    expect(page).to have_link('Registrar')
    expect(page).not_to have_content(invalid_user[:email])
    expect(page).not_to have_link('Sair')
  end
end
