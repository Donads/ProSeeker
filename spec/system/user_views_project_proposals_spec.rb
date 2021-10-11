require 'rails_helper'

describe 'User views project proposals' do
  context 'on their own projects' do
    it 'successfully' do
      birth_date = 30.years.ago.to_date
      future_date = 2.months.from_now.to_date
      user_1 = User.create!(email: 'usuario1@teste.com.br', password: '123456', role: :user)
      user_2 = User.create!(email: 'usuario2@teste.com.br', password: '123456', role: :user)
      project_1 = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                                  skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                                  attendance_type: :remote_attendance, user: user_1)
      project_2 = Project.create!(title: 'Desenvolvimento no cliente', description: 'Desenvolver customizações em sistema',
                                  skills: 'Comunicação e regras de negócio', max_hourly_rate: 50, open_until: future_date,
                                  attendance_type: :presential_attendance, user: user_2)
      professional_1 = User.create!(email: 'profissional1@teste.com.br', password: '123456',
                                    role: :professional)
      ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                  description: 'Busco projetos desafiadores',
                                  professional_qualification: 'Ensino Superior',
                                  professional_experience: '6 anos trabalhando em projetos diversos',
                                  birth_date: birth_date, user: professional_1)
      professional_2 = User.create!(email: 'profissional2@teste.com.br', password: '123456',
                                    role: :professional)
      ProfessionalProfile.create!(full_name: 'George Washington', social_name: 'Antonio Nunes',
                                  description: 'Desenvolvedor com anos de experiência',
                                  professional_qualification: 'Ensino Superior',
                                  professional_experience: '15 anos trabalhando em projetos diversos',
                                  birth_date: birth_date, user: professional_2)
      ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                              hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project_1,
                              user: professional_1)
      ProjectProposal.create!(reason: 'Sou especialista em atendimento presencial',
                              hourly_rate: 40.0, weekly_hours: 20, deadline: future_date, project: project_2,
                              user: professional_1)
      ProjectProposal.create!(reason: 'Domino o desenvolvimento de projetos web',
                              hourly_rate: 80.0, weekly_hours: 40, deadline: future_date, project: project_1,
                              user: professional_2)

      login_as user_1, scope: :user
      visit root_path
      click_link 'Projetos'
      click_link 'Projeto de E-commerce'

      expect(current_path).to eq project_path(project_1)
      expect(page).to have_link('Ciclano da Silva')
      expect(page).to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(page).to have_link('Antonio Nunes')
      expect(page).to have_content('Domino o desenvolvimento de projetos web')
    end

    it 'and views professional profile' do
      birth_date = 30.years.ago.to_date
      future_date = 2.months.from_now.to_date
      user_1 = User.create!(email: 'usuario1@teste.com.br', password: '123456', role: :user)
      user_2 = User.create!(email: 'usuario2@teste.com.br', password: '123456', role: :user)
      project_1 = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                                  skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                                  attendance_type: :remote_attendance, user: user_1)
      project_2 = Project.create!(title: 'Desenvolvimento no cliente', description: 'Desenvolver customizações em sistema',
                                  skills: 'Comunicação e regras de negócio', max_hourly_rate: 50, open_until: future_date,
                                  attendance_type: :presential_attendance, user: user_2)
      professional_1 = User.create!(email: 'profissional1@teste.com.br', password: '123456',
                                    role: :professional)
      ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                  description: 'Busco projetos desafiadores',
                                  professional_qualification: 'Ensino Superior',
                                  professional_experience: '6 anos trabalhando em projetos diversos',
                                  birth_date: birth_date, user: professional_1)
      professional_2 = User.create!(email: 'profissional2@teste.com.br', password: '123456',
                                    role: :professional)
      ProfessionalProfile.create!(full_name: 'George Washington', social_name: 'Antonio Nunes',
                                  description: 'Desenvolvedor com anos de experiência',
                                  professional_qualification: 'Ensino Superior',
                                  professional_experience: '15 anos trabalhando em projetos diversos',
                                  birth_date: birth_date, user: professional_2)
      ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                              hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project_1,
                              user: professional_1)
      ProjectProposal.create!(reason: 'Sou especialista em atendimento presencial',
                              hourly_rate: 40.0, weekly_hours: 20, deadline: future_date, project: project_2,
                              user: professional_1)
      ProjectProposal.create!(reason: 'Domino o desenvolvimento de projetos web',
                              hourly_rate: 80.0, weekly_hours: 40, deadline: future_date, project: project_1,
                              user: professional_2)

      login_as user_1, scope: :user
      visit root_path
      click_link 'Projetos'
      click_link 'Projeto de E-commerce'
      click_link 'Ciclano da Silva'

      expect(current_path).to eq professional_profile_path(professional_1.professional_profile)
      expect(page).to have_content('Perfil Completo')
      expect(page).to have_content('Nome Completo')
      expect(page).to have_content('Fulano de Tal')
      expect(page).to have_content('Nome Social')
      expect(page).to have_content('Ciclano da Silva')
    end
  end

  context 'on other users projects' do
    it 'and does not see them' do
      birth_date = 30.years.ago.to_date
      future_date = 2.months.from_now.to_date
      user_1 = User.create!(email: 'usuario1@teste.com.br', password: '123456', role: :user)
      user_2 = User.create!(email: 'usuario2@teste.com.br', password: '123456', role: :user)
      project_1 = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                                  skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                                  attendance_type: :remote_attendance, user: user_1)
      project_2 = Project.create!(title: 'Desenvolvimento no cliente', description: 'Desenvolver customizações em sistema',
                                  skills: 'Comunicação e regras de negócio', max_hourly_rate: 50, open_until: future_date,
                                  attendance_type: :presential_attendance, user: user_2)
      professional_1 = User.create!(email: 'profissional1@teste.com.br', password: '123456',
                                    role: :professional)
      ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                  description: 'Busco projetos desafiadores',
                                  professional_qualification: 'Ensino Superior',
                                  professional_experience: '6 anos trabalhando em projetos diversos',
                                  birth_date: birth_date, user: professional_1)
      professional_2 = User.create!(email: 'profissional2@teste.com.br', password: '123456',
                                    role: :professional)
      ProfessionalProfile.create!(full_name: 'George Washington', social_name: 'Antonio Nunes',
                                  description: 'Desenvolvedor com anos de experiência',
                                  professional_qualification: 'Ensino Superior',
                                  professional_experience: '15 anos trabalhando em projetos diversos',
                                  birth_date: birth_date, user: professional_2)
      ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                              hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project_1,
                              user: professional_1)
      ProjectProposal.create!(reason: 'Sou especialista em atendimento presencial',
                              hourly_rate: 40.0, weekly_hours: 20, deadline: future_date, project: project_2,
                              user: professional_1)
      ProjectProposal.create!(reason: 'Domino o desenvolvimento de projetos web',
                              hourly_rate: 80.0, weekly_hours: 40, deadline: future_date, project: project_1,
                              user: professional_2)

      login_as user_1, scope: :user
      visit root_path
      click_link 'Projetos'
      click_link 'Desenvolvimento no cliente'

      expect(current_path).to eq project_path(project_2)
      expect(page).not_to have_content('Propostas enviadas:')
      expect(page).not_to have_content('Ciclano da Silva')
      expect(page).not_to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(page).not_to have_content('Antonio Nunes')
      expect(page).not_to have_content('Domino o desenvolvimento de projetos web')
    end
  end
end
