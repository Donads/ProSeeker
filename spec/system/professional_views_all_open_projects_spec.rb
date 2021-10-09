require 'rails_helper'

describe 'Professional views all open projects' do
  it 'successfully' do
    professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: '1990-12-31', user: professional)
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                    skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: '31/12/2021',
                    attendance_type: :remote_attendance, user: user)
    Project.create!(title: 'Desenvolvimento no cliente', description: 'Desenvolver customizações em sistema',
                    skills: 'Comunicação e regras de negócio', max_hourly_rate: 50, open_until: '25/12/2021',
                    attendance_type: :presential_attendance, user: user)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'

    expect(current_path).to eq projects_path
    expect(page).to have_link('Projeto de E-commerce')
    expect(page).to have_link('Desenvolvimento no cliente')
  end

  it 'and filters by status' do
    # TODO: Add status filtering
  end
end
