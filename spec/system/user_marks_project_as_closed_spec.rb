require 'rails_helper'

describe 'User marks project as closed' do
  context 'with approved proposals' do
    it 'successfully' do
      birth_date = 30.years.ago.to_date
      future_date = 2.months.from_now.to_date
      photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
      knowledge_field = KnowledgeField.create!(title: 'Desenvolvedor')
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
                                              birth_date: birth_date, user: professional_1, knowledge_field: knowledge_field, profile_photo: photo)
      professional_2 = User.create!(email: 'profissional2@teste.com.br', password: '123456',
                                    role: :professional)
      profile_2 = ProfessionalProfile.create!(full_name: 'George Washington', social_name: 'Antonio Nunes',
                                              description: 'Desenvolvedor com anos de experiência',
                                              professional_qualification: 'Ensino Superior',
                                              professional_experience: '15 anos trabalhando em projetos diversos',
                                              birth_date: birth_date, user: professional_2, knowledge_field: knowledge_field, profile_photo: photo)
      ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                              hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project,
                              user: professional_1, status: :approved)
      ProjectProposal.create!(reason: 'Domino o desenvolvimento de projetos web',
                              hourly_rate: 80.0, weekly_hours: 40, deadline: future_date, project: project,
                              user: professional_2, status: :approved)

      login_as user, scope: :user
      visit root_path
      click_link 'Projetos'
      click_link 'Projeto de E-commerce'
      click_link 'Fechar'

      expect(current_path).to eq project_path(project)
      expect(page).to have_content('Situação: Fechado')
      expect(page).to have_link('Finalizar', href: finish_project_path(project))
      expect(page).to have_link('Ciclano da Silva', href: professional_profile_path(profile_1))
      expect(page).to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(page).to have_link('Antonio Nunes', href: professional_profile_path(profile_2))
      expect(page).to have_content('Domino o desenvolvimento de projetos web')
      expect(page).to have_no_link('Editar')
      expect(page).to have_no_link('Fechar')
    end
  end
end
