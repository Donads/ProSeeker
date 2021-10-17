require 'rails_helper'

describe 'Visitor signs up' do
  context 'as an user' do
    it 'successfully' do
      user = { email: 'usuario@teste.com.br', password: '123456' }

      visit root_path
      click_link 'Registrar'
      within 'form' do
        fill_in 'E-mail', with: user[:email]
        fill_in 'Senha (Mínimo', with: user[:password]
        fill_in 'Confirmação de Senha', with: user[:password]
        choose 'user_role_user'
        click_button 'Registrar'
      end

      expect(page).to have_content('Login efetuado com sucesso.')
      expect(page).to have_content("Logado como '#{user[:email]}' (Usuário)")
      expect(page).to have_link('Sair', href: destroy_user_session_path)
      expect(page).to have_no_link('Entrar')
      expect(page).to have_no_link('Registrar')
    end
  end

  context 'as a professional' do
    it 'successfully' do
      professional = { email: 'profissional@teste.com.br', password: '123456' }

      visit root_path
      click_link 'Registrar'
      within 'form' do
        fill_in 'E-mail', with: professional[:email]
        fill_in 'Senha (Mínimo', with: professional[:password]
        fill_in 'Confirmação de Senha', with: professional[:password]
        choose 'user_role_professional'
        click_button 'Registrar'
      end

      expect(current_path).to eq new_professional_profile_path
      expect(page).to have_css('div',
                               text: 'Profissionais devem preencher o perfil por completo antes de terem acesso às funcionalidades da plataforma.')
      expect(page).to have_content("Logado como '#{professional[:email]}' (Profissional)")
      expect(page).to have_link('Sair', href: destroy_user_session_path)
      expect(page).to have_no_link('Entrar')
      expect(page).to have_no_link('Registrar')
    end
  end

  it 'and fails' do
    invalid_user = { email: 'usuario', password: '12345', password_confirmation: '1234' }

    visit root_path
    click_link 'Registrar'
    within 'form' do
      fill_in 'E-mail', with: invalid_user[:email]
      fill_in 'Senha (Mínimo', with: invalid_user[:password]
      fill_in 'Confirmação de Senha', with: invalid_user[:password_confirmation]
      click_button 'Registrar'
    end

    expect(page).to have_content('Não foi possível salvar usuário: 5 erros')
    expect(page).to have_content('E-mail não é válido')
    expect(page).to have_content('Confirmação de Senha não é igual a Senha')
    expect(page).to have_content('Senha é muito curto (mínimo: 6 caracteres)')
    expect(page).to have_content('Função não pode ficar em branco')
    expect(page).to have_content('Função não está incluído na lista')
    expect(page).to have_link('Entrar', href: new_user_session_path)
    expect(page).to have_link('Registrar', href: new_user_registration_path)
    expect(page).to have_no_link('Sair')
  end
end
