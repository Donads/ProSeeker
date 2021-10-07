require 'rails_helper'

describe 'User creates project' do
  it 'successfully' do
    user = User.create!(email: 'usuario@teste.com.br', password: '123456')
    project = { title: 'Teste de título', description: 'Teste de descrição', skills: 'Teste de habilidades', max_hourly_rate: 60, open_until: '31/12/2021',
                attendance_type: 'Remoto' }

    login_as user, scope: :user
    visit root_path
    click_link 'Cadastrar Novo Projeto'
    within 'form' do
      fill_in 'Título', with: project[:title]
      fill_in 'Descrição', with: project[:description]
      fill_in 'Habilidades desejadas', with: project[:skills]
      fill_in 'Valor máximo (R$/hora)', with: project[:max_hourly_rate]
      fill_in 'Prazo para recebimento de propostas', with: project[:open_until]
      fill_in 'Tipo de atuação', with: project[:attendance_type]
      click_button 'Criar Projeto'
    end

    expect(current_path).to eq project_path(Project.last)
    expect(page).to have_content('Projeto cadastrado com sucesso!')
    expect(page).to have_content(project[:title])
    expect(page).to have_content(project[:description])
    expect(page).to have_content(project[:skills])
    expect(page).to have_content("R$ #{project[:max_hourly_rate]}")
    expect(page).to have_content(project[:open_until])
    expect(page).to have_content(project[:attendance_type])
    expect(current_path).not_to eq new_project_path
  end
end
