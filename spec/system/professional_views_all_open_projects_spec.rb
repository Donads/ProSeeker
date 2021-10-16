require 'rails_helper'

describe 'Professional views all open projects' do
  it 'successfully' do
    birth_date = 30.years.ago.to_date
    future_date = 2.months.from_now.to_date
    photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
    professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: birth_date, user: professional, profile_photo: photo)
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    project_1 = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                                skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                                attendance_type: :remote_attendance, user: user)
    project_2 = Project.create!(title: 'Desenvolvimento no cliente', description: 'Desenvolver customizações em sistema',
                                skills: 'Comunicação e regras de negócio', max_hourly_rate: 50, open_until: future_date,
                                attendance_type: :presential_attendance, user: user)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'

    expect(current_path).to eq projects_path
    expect(page).to have_link('Projeto de E-commerce', href: project_path(project_1))
    expect(page).to have_link('Desenvolvimento no cliente', href: project_path(project_2))
  end

  it 'and filters by status' do
    # TODO: Add status filtering
  end
end
