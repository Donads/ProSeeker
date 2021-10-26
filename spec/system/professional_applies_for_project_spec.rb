require 'rails_helper'

describe 'Professional applies for project' do
  it 'successfully' do
    birth_date = 30.years.ago.to_date
    future_date = 2.months.from_now.to_date
    photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
    knowledge_field = KnowledgeField.create!(title: 'Desenvolvedor')
    professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: birth_date, user: professional, knowledge_field: knowledge_field, profile_photo: photo)
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                              skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                              attendance_type: :remote_attendance, user: user)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'
    click_link 'Projeto de E-commerce'
    within 'form' do
      fill_in 'Motivo', with: 'Gosto muito de trabalhar com e-commerces e tenho experiência'
      fill_in 'Valor (R$/hora)', with: 70.0
      fill_in 'Disponibilidade de horas por semana', with: 30
      fill_in 'Expectativa de conclusão', with: future_date
      click_button 'Criar Proposta'
    end

    expect(current_path).to eq project_path(project)
    expect(page).to have_css('div', text: 'Proposta enviada com sucesso!')
    expect(page).to have_content('Ciclano da Silva, você enviou a seguinte proposta para esse projeto:')
    expect(page).to have_field('Motivo', with: 'Gosto muito de trabalhar com e-commerces e tenho experiência')
    expect(page).to have_field('Valor (R$/hora)', with: 70.0)
    expect(page).to have_field('Disponibilidade de horas por semana', with: 30)
    expect(page).to have_field('Expectativa de conclusão', with: future_date)
    expect(page).to have_content('Pendente')
  end

  it 'but fails due to missing fields' do
    birth_date = 30.years.ago.to_date
    future_date = 2.months.from_now.to_date
    photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
    knowledge_field = KnowledgeField.create!(title: 'Desenvolvedor')
    professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: birth_date, user: professional, knowledge_field: knowledge_field, profile_photo: photo)
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                              skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                              attendance_type: :remote_attendance, user: user)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'
    click_link 'Projeto de E-commerce'
    within 'form' do
      click_button 'Criar Proposta'
    end

    expect(current_path).to eq project_path(project)
    expect(page).to have_css('div', text: 'Erro ao inserir a proposta!')
    expect(page).to have_content('Ciclano da Silva, envie sua proposta para esse projeto preenchendo os campos abaixo:')
  end

  it 'and edits it successfully' do
    birth_date = 30.years.ago.to_date
    future_date = 2.months.from_now.to_date
    photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
    knowledge_field = KnowledgeField.create!(title: 'Desenvolvedor')
    professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: birth_date, user: professional, knowledge_field: knowledge_field, profile_photo: photo)
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                              skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                              attendance_type: :remote_attendance, user: user)
    ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                            hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project,
                            user: professional)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'
    click_link 'Projeto de E-commerce'
    fill_in 'Valor (R$/hora)', with: 65.8
    fill_in 'Expectativa de conclusão', with: future_date - 10.days
    click_button 'Atualizar Proposta'

    expect(current_path).to eq project_path(project)
    expect(page).to have_css('div', text: 'Proposta atualizada com sucesso!')
    expect(page).to have_content('Ciclano da Silva, você enviou a seguinte proposta para esse projeto:')
    expect(page).to have_field('Motivo', with: 'Gosto muito de trabalhar com e-commerces e tenho experiência')
    expect(page).to have_field('Valor (R$/hora)', with: 65.8)
    expect(page).to have_field('Disponibilidade de horas por semana', with: 30)
    expect(page).to have_field('Expectativa de conclusão', with: future_date - 10.days)
    expect(page).to have_content('Pendente')
  end

  it 'and removes their proposal before it was approved' do
    birth_date = 30.years.ago.to_date
    future_date = 2.months.from_now.to_date
    photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
    knowledge_field = KnowledgeField.create!(title: 'Desenvolvedor')
    professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: birth_date, user: professional, knowledge_field: knowledge_field, profile_photo: photo)
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                              skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                              attendance_type: :remote_attendance, user: user)
    ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                            hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project,
                            user: professional)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'
    click_link 'Projeto de E-commerce'
    click_button 'Cancelar Proposta'

    expect(current_path).to eq project_path(project)
    expect(page).to have_css('div', text: 'Proposta cancelada com sucesso!')
    expect(page).to have_content('Ciclano da Silva, envie sua proposta para esse projeto preenchendo os campos abaixo:')
  end

  it 'and successfully removes their proposal after it was approved' do
    birth_date = 30.years.ago.to_date
    future_date = 2.months.from_now.to_date
    photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
    knowledge_field = KnowledgeField.create!(title: 'Desenvolvedor')
    professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: birth_date, user: professional, knowledge_field: knowledge_field, profile_photo: photo)
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                              skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                              attendance_type: :remote_attendance, user: user)
    proposal = ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                                       hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project,
                                       user: professional, status: :approved, status_date: 2.days.ago)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'
    click_link 'Projeto de E-commerce'
    click_link 'Cancelar Proposta'
    fill_in 'Motivo da Situação', with: 'Assuntos urgentes surgiram e não terei disponibilidade'
    click_button 'Atualizar Proposta'

    expect(current_path).to eq project_path(project)
    expect(page).to have_css('div', text: 'Proposta cancelada com sucesso!')
    expect(proposal.reload.status).to eq 'canceled'
    expect(page).to have_content('Ciclano da Silva, você enviou a seguinte proposta para esse projeto:')
    expect(page).to have_content('Cancelada')
  end

  it 'and fails to remove their proposal after it was approved due to not providing a reason' do
    birth_date = 30.years.ago.to_date
    future_date = 2.months.from_now.to_date
    photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
    knowledge_field = KnowledgeField.create!(title: 'Desenvolvedor')
    professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: birth_date, user: professional, knowledge_field: knowledge_field, profile_photo: photo)
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                              skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                              attendance_type: :remote_attendance, user: user)
    proposal = ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                                       hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project,
                                       user: professional, status: :approved)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'
    click_link 'Projeto de E-commerce'
    click_link 'Cancelar Proposta'
    fill_in 'Motivo da Situação', with: ''
    click_button 'Atualizar Proposta'

    expect(current_path).to eq project_proposal_path(proposal)
    expect(page).to have_css('div', text: 'Motivo da Situação não pode ficar em branco')
    expect(page).to have_content("Justifique o cancelamento da proposta para o projeto #{project.title}")
    expect(proposal.reload.status).to eq 'approved'
    expect(page).to have_no_content('Proposta rejeitada com sucesso')
  end

  it 'and does not see the cancel options due to elapsed time since approval' do
    birth_date = 30.years.ago.to_date
    future_date = 2.months.from_now.to_date
    photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
    knowledge_field = KnowledgeField.create!(title: 'Desenvolvedor')
    professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: birth_date, user: professional, knowledge_field: knowledge_field, profile_photo: photo)
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                              skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                              attendance_type: :remote_attendance, user: user)
    proposal = ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                                       hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project,
                                       user: professional, status: :approved)
    proposal.status_date = 4.days.ago
    proposal.save(validate: false)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'
    click_link 'Projeto de E-commerce'

    expect(current_path).to eq project_path(project)
    expect(proposal.reload.status).to eq 'approved'
    expect(page).to have_content('Ciclano da Silva, você enviou a seguinte proposta para esse projeto:')
    expect(page).to have_content('Aprovada')
    expect(page).to have_no_button('Cancelar Proposta')
    expect(page).to have_no_link('Cancelar Proposta')
  end
end
