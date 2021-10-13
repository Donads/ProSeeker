require 'rails_helper'

describe 'User creates project' do
  it 'successfully' do
    future_date = 2.months.from_now.to_date
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    project = { title: 'Teste de título', description: 'Teste de descrição', skills: 'Teste de habilidades',
                max_hourly_rate: 60, open_until: future_date, attendance_type: :remote_attendance }

    login_as user, scope: :user
    visit root_path
    click_link 'Cadastrar Novo Projeto'
    within 'form' do
      fill_in 'Título', with: project[:title]
      fill_in 'Descrição', with: project[:description]
      fill_in 'Habilidades desejadas', with: project[:skills]
      fill_in 'Valor máximo (R$/hora)', with: project[:max_hourly_rate]
      fill_in 'Prazo para recebimento de propostas', with: project[:open_until]
      choose 'project_attendance_type_remote_attendance'
      click_button 'Criar Projeto'
    end

    expect(current_path).to eq project_path(Project.last)
    expect(page).to have_content('Projeto cadastrado com sucesso!')
    expect(page).to have_content('Situação: Aberto')
    expect(page).to have_link('Editar')
    expect(page).to have_link('Fechar')
    expect(page).to have_content(project[:title])
    expect(page).to have_content(project[:description])
    expect(page).to have_content(project[:skills])
    expect(page).to have_content("R$ #{project[:max_hourly_rate]}")
    expect(page).to have_content(I18n.l(future_date))
    expect(page).to have_content(I18n.t(project[:attendance_type]))
    expect(page).not_to have_link('Finalizar')
    expect(current_path).not_to eq new_project_path
  end

  it 'and fails due to failed validations' do
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)

    login_as user, scope: :user
    visit root_path
    click_link 'Cadastrar Novo Projeto'
    within 'form' do
      fill_in 'Título', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Habilidades desejadas', with: ''
      fill_in 'Valor máximo (R$/hora)', with: 0
      fill_in 'Prazo para recebimento de propostas', with: ''
      click_button 'Criar Projeto'
    end

    expect(current_path).to eq projects_path
    expect(page).to have_content('Título não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Habilidades desejadas não pode ficar em branco')
    expect(page).to have_content('Prazo para recebimento de propostas não pode ficar em branco')
    expect(page).to have_content('Tipo de atuação não pode ficar em branco')
    expect(page).to have_content('Valor máximo (R$/hora) deve ser maior que 0')
  end
end
