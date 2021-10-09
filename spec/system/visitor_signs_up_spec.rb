require 'rails_helper'

describe 'Visitor signs up' do
  context 'as an user' do
    it 'successfully' do
      user = { email: 'usuario@teste.com.br', password: '123456' }

      visit root_path
      click_link 'Registrar'
      within 'form' do
        fill_in 'E-mail', with: user[:email]
        fill_in 'Senha', with: user[:password]
        fill_in 'Confirmação de Senha', with: user[:password]
        choose 'user_role_user'
        click_button 'Registrar'
      end

      expect(page).to have_content('Login efetuado com sucesso.')
      expect(page).to have_content("Logado como '#{user[:email]}' (Usuário)")
      expect(page).to have_link('Sair')
      expect(page).not_to have_link('Entrar')
      expect(page).not_to have_link('Registrar')
    end
  end

  context 'as a professional' do
    it 'successfully' do
      professional = { email: 'profissional@teste.com.br', password: '123456' }

      visit root_path
      click_link 'Registrar'
      within 'form' do
        fill_in 'E-mail', with: professional[:email]
        fill_in 'Senha', with: professional[:password]
        fill_in 'Confirmação de Senha', with: professional[:password]
        choose 'user_role_professional'
        click_button 'Registrar'
      end

      expect(page).to have_content('Login efetuado com sucesso.')
      expect(page).to have_content("Logado como '#{professional[:email]}' (Profissional)")
      expect(page).to have_link('Sair')
      expect(page).not_to have_link('Entrar')
      expect(page).not_to have_link('Registrar')
    end
  end
end
