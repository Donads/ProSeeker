require 'rails_helper'

describe 'Professional views project team' do
  it 'successfully' do
    birth_date = 30.years.ago.to_date
    future_date = 2.months.from_now.to_date
    photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
    user = User.create!(email: 'usuario1@teste.com.br', password: '123456', role: :user)
    project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                              skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                              attendance_type: :remote_attendance, user: user)
    professional_1 = User.create!(email: 'profissional1@teste.com.br', password: '123456',
                                  role: :professional)
    profile_1 = ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                            description: 'Busco projetos desafiadores',
                                            professional_qualification: 'Ensino Superior',
                                            professional_experience: '6 anos trabalhando em projetos diversos',
                                            birth_date: birth_date, user: professional_1, profile_photo: photo)
    professional_2 = User.create!(email: 'profissional2@teste.com.br', password: '123456',
                                  role: :professional)
    profile_2 = ProfessionalProfile.create!(full_name: 'George Washington', social_name: 'Antonio Nunes',
                                            description: 'Desenvolvedor com anos de experiência',
                                            professional_qualification: 'Ensino Superior',
                                            professional_experience: '15 anos trabalhando em projetos diversos',
                                            birth_date: birth_date, user: professional_2, profile_photo: photo)
    professional_3 = User.create!(email: 'profissional3@teste.com.br', password: '123456',
                                  role: :professional)
    profile_3 = ProfessionalProfile.create!(full_name: 'Maria Eduarda', social_name: 'Maria Eduarda',
                                            description: 'Desenvolvedora experiente',
                                            professional_qualification: 'Doutorado',
                                            professional_experience: '10 anos trabalhando em projetos diversos',
                                            birth_date: birth_date, user: professional_3, profile_photo: photo)
    proposal_1 = ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                                         hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project,
                                         user: professional_1, status: :approved)
    proposal_2 = ProjectProposal.create!(reason: 'Domino o desenvolvimento de projetos web',
                                         hourly_rate: 80.0, weekly_hours: 40, deadline: future_date, project: project,
                                         user: professional_2, status: :rejected)
    proposal_3 = ProjectProposal.create!(reason: 'Sou especialista em e-commerces',
                                         hourly_rate: 80.0, weekly_hours: 50, deadline: future_date, project: project,
                                         user: professional_3, status: :approved)
    project.closed!

    login_as professional_1, scope: :user
    visit root_path
    click_link 'Meus Projetos'
    click_link 'Projeto de E-commerce'

    expect(current_path).to eq project_path(project)
    expect(proposal_1.reload.status).to eq 'approved'
    expect(proposal_2.reload.status).to eq 'rejected'
    expect(proposal_3.reload.status).to eq 'approved'
    expect(page).to have_content('você enviou a seguinte proposta para esse projeto')
    expect(page).to have_link('Ciclano da Silva', href: professional_profile_path(profile_1))
    expect(page).to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
    expect(page).to have_link('Maria Eduarda', href: professional_profile_path(profile_3))
    expect(page).to have_content('Sou especialista em e-commerces')
    expect(page).to have_no_content('Antonio Nunes')
    expect(page).to have_no_content('Domino o desenvolvimento de projetos web')
  end
end
