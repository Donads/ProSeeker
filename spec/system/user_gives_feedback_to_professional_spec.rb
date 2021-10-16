require 'rails_helper'

describe 'User gives feedback to professional' do
  context 'after the project is finished' do
    it 'successfully' do
      birth_date = 30.years.ago.to_date
      future_date = 2.months.from_now.to_date
      user = User.create!(email: 'usuario1@teste.com.br', password: '123456', role: :user)
      project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                                skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                                attendance_type: :remote_attendance, user: user)
      professional_1 = User.create!(email: 'profissional1@teste.com.br', password: '123456',
                                    role: :professional)
      photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
      ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                  description: 'Busco projetos desafiadores',
                                  professional_qualification: 'Ensino Superior',
                                  professional_experience: '6 anos trabalhando em projetos diversos',
                                  birth_date: birth_date, user: professional_1, profile_photo: photo)
      professional_2 = User.create!(email: 'profissional2@teste.com.br', password: '123456',
                                    role: :professional)
      ProfessionalProfile.create!(full_name: 'George Washington', social_name: 'Antonio Nunes',
                                  description: 'Desenvolvedor com anos de experiência',
                                  professional_qualification: 'Ensino Superior',
                                  professional_experience: '15 anos trabalhando em projetos diversos',
                                  birth_date: birth_date, user: professional_2, profile_photo: photo)
      proposal_1 = ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                                           hourly_rate: 70.0, weekly_hours: 30, deadline: future_date, project: project,
                                           user: professional_1, status: :approved)
      proposal_2 = ProjectProposal.create!(reason: 'Domino o desenvolvimento de projetos web',
                                           hourly_rate: 80.0, weekly_hours: 40, deadline: future_date, project: project,
                                           user: professional_2, status: :approved)
      project.finished!
      feedback = { score: 5, user_feedback: 'Profissional dedicado' }

      login_as user, scope: :user
      visit root_path
      click_link 'Meus Projetos'
      click_link 'Projeto de E-commerce'
      find('tr[project-proposal-id="2"]').click_link('Avaliar')
      fill_in 'Avaliação do usuário', with: feedback[:user_feedback]
      choose feedback[:score].to_s
      click_button 'Criar Avaliação'

      expect(current_path).to eq project_path(project)
      expect(page).to have_css('div', text: 'Avaliação enviada com sucesso!')
      expect(proposal_1.reload.status).to eq 'approved'
      expect(proposal_2.reload.status).to eq 'rated'
      expect(professional_2.reload.average_score_received?).to eq feedback[:score]
      expect(page).to have_content('Situação: Finalizado')
      expect(page).to have_link('Ciclano da Silva')
      expect(page).to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(page).to have_link('Antonio Nunes')
      expect(page).to have_content('Domino o desenvolvimento de projetos web')
      expect(page).to have_link('Avaliar')
      expect(page).not_to have_link('Editar')
      expect(page).not_to have_link('Fechar')
      expect(page).not_to have_link('Finalizar')
    end
  end
end
