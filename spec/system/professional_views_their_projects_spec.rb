require 'rails_helper'

describe 'Professional views their projects' do
  it 'successfully' do
    birth_date = 30.years.ago.to_date
    future_date = 2.months.from_now.to_date
    photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
    knowledge_field = KnowledgeField.create!(title: 'Desenvolvedor')
    user = User.create!(email: 'usuario1@teste.com.br', password: '123456', role: :user)
    project_1 = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                                skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                                attendance_type: :remote_attendance, user: user)
    project_2 = Project.create!(title: 'Desenvolvimento no cliente', description: 'Desenvolver customizações em sistema',
                                skills: 'Comunicação e regras de negócio', max_hourly_rate: 100, open_until: future_date,
                                attendance_type: :presential_attendance, user: user)
    professional = User.create!(email: 'profissional1@teste.com.br', password: '123456',
                                role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: birth_date, user: professional, knowledge_field: knowledge_field,
                                profile_photo: photo)
    proposal_1 = ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                                         hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project_1,
                                         user: professional, status: :approved)
    proposal_2 = ProjectProposal.create!(reason: 'Domino o desenvolvimento de projetos web',
                                         hourly_rate: 80.0, weekly_hours: 40, deadline: future_date, project: project_2,
                                         user: professional, status: :approved)
    project_1.closed!
    project_2.finished!

    login_as professional, scope: :user
    visit root_path
    click_link 'Meus Projetos'

    expect(current_path).to eq my_projects_projects_path
    expect(page).to have_link('Projeto de E-commerce', href: project_path(project_1))
    expect(page).to have_link('Desenvolvimento no cliente', href: project_path(project_2))
  end

  it 'and filters by title or description' do
    birth_date = 30.years.ago.to_date
    future_date = 2.months.from_now.to_date
    photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
    knowledge_field = KnowledgeField.create!(title: 'Desenvolvedor')
    user = User.create!(email: 'usuario1@teste.com.br', password: '123456', role: :user)
    project_1 = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                                skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                                attendance_type: :remote_attendance, user: user)
    project_2 = Project.create!(title: 'Desenvolvimento no cliente', description: 'Desenvolver customizações em sistema',
                                skills: 'Comunicação e regras de negócio', max_hourly_rate: 100, open_until: future_date,
                                attendance_type: :presential_attendance, user: user)
    professional = User.create!(email: 'profissional1@teste.com.br', password: '123456',
                                role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: birth_date, user: professional, knowledge_field: knowledge_field,
                                profile_photo: photo)
    proposal_1 = ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                                         hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project_1,
                                         user: professional, status: :approved)
    proposal_2 = ProjectProposal.create!(reason: 'Domino o desenvolvimento de projetos web',
                                         hourly_rate: 80.0, weekly_hours: 40, deadline: future_date, project: project_2,
                                         user: professional, status: :approved)
    project_1.closed!
    project_2.finished!

    login_as professional, scope: :user
    visit root_path
    click_link 'Meus Projetos'
    fill_in :query, with: 'customi'
    click_button 'Buscar'

    expect(current_path).to eq my_projects_projects_path
    expect(page).to have_no_link('Projeto de E-commerce')
    expect(page).to have_link('Desenvolvimento no cliente', href: project_path(project_2))
  end
end
