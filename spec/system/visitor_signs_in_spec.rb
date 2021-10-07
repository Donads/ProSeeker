require 'rails_helper'

describe 'Visitor signs in' do
  context 'as an user' do
    it 'successfully' do
      user = User.create!(email: 'usuario@teste.com.br', password: '123456')

      visit root_path
      click_link 'Entrar'
      within 'form' do
        fill_in 'E-mail', with: user.email
        fill_in 'Senha', with: user.password
        click_button 'Entrar'
      end

      expect(page).to have_content('Login efetuado com sucesso!')
      expect(page).to have_content("Logado como '#{user.email}'")
      expect(page).to have_link('Sair')
      expect(page).not_to have_link('Entrar')
      expect(page).not_to have_link('Registrar')
    end

    it 'with invalid credentials' do
      user = { email: 'usuario@teste.com.br', password: '123456' }

      visit root_path
      click_link 'Entrar'
      within 'form' do
        fill_in 'E-mail', with: user[:email]
        fill_in 'Senha', with: user[:password]
        click_button 'Entrar'
      end

      expect(current_path).to eq new_user_session_path
      expect(page).to have_content('E-mail ou senha inválida')
      expect(page).to have_link('Entrar')
      expect(page).to have_link('Registrar')
      expect(page).not_to have_content(user[:email])
      expect(page).not_to have_link('Sair')
    end

    it 'and logs out' do
      user = User.create!(email: 'usuario@teste.com.br', password: '123456')

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
  end
end
