require 'rails_helper'

describe 'User marks project as finished' do
  context 'with approved proposals' do
    it 'successfully' do
      birth_date = 30.years.ago.to_date
      future_date = 2.months.from_now.to_date
      user = User.create!(email: 'usuario1@teste.com.br', password: '123456', role: :user)
      project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                                skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                                attendance_type: :remote_attendance, user: user)
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
                              hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project,
                              user: professional_1, status: :approved)
      ProjectProposal.create!(reason: 'Domino o desenvolvimento de projetos web',
                              hourly_rate: 80.0, weekly_hours: 40, deadline: future_date, project: project,
                              user: professional_2, status: :approved)
      project.closed!

      login_as user, scope: :user
      visit root_path
      click_link 'Projetos'
      click_link 'Projeto de E-commerce'
      click_link 'Finalizar'

      expect(current_path).to eq project_path(project)
      expect(page).to have_content('Situação: Finalizado')
      expect(page).to have_link('Ciclano da Silva')
      expect(page).to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(page).to have_link('Antonio Nunes')
      expect(page).to have_content('Domino o desenvolvimento de projetos web')
      expect(page).not_to have_link('Editar')
      expect(page).not_to have_link('Fechar')
      expect(page).not_to have_link('Finalizar')
    end
  end
end
