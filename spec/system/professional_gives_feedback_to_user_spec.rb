require 'rails_helper'

describe 'Professional gives feedback to user' do
  context 'after the project is finished' do
    it 'successfully' do
      birth_date = 30.years.ago.to_date
      future_date = 2.months.from_now.to_date
      photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
      user = User.create!(email: 'usuario1@teste.com.br', password: '123456', role: :user)
      project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                                skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: future_date,
                                attendance_type: :remote_attendance, user: user)
      professional = User.create!(email: 'profissional2@teste.com.br', password: '123456',
                                  role: :professional)
      ProfessionalProfile.create!(full_name: 'George Washington', social_name: 'Antonio Nunes',
                                  description: 'Desenvolvedor com anos de experiência',
                                  professional_qualification: 'Ensino Superior',
                                  professional_experience: '15 anos trabalhando em projetos diversos',
                                  birth_date: birth_date, user: professional, profile_photo: photo)
      proposal = ProjectProposal.create!(reason: 'Domino o desenvolvimento de projetos web',
                                         hourly_rate: 80.0, weekly_hours: 40, deadline: future_date, project: project,
                                         user: professional, status: :approved)
      project.finished!
      feedback_params = { score: 5, user_feedback: 'Gerente responsável', project_feedback: 'Projeto desafiador' }

      login_as professional, scope: :user
      visit root_path
      click_link 'Meus Projetos'
      click_link 'Projeto de E-commerce'
      click_link 'Avaliar Projeto'
      fill_in 'Avaliação do usuário', with: feedback_params[:user_feedback]
      fill_in 'Avaliação do projeto', with: feedback_params[:project_feedback]
      choose feedback_params[:score].to_s
      click_button 'Criar Avaliação'

      feedback = project.feedback_from_professional(professional)
      expect(current_path).to eq project_path(project)
      expect(page).to have_css('div', text: 'Avaliação enviada com sucesso!')
      expect(feedback.project_feedback).to include(feedback_params[:project_feedback])
      expect(user.reload.average_score_received?).to eq feedback_params[:score]
      expect(page).to have_content('Usuário responsável: usuario1@teste.com.br (Nota média: 5.0)')
      expect(page).to have_content('Situação: Finalizado')
      expect(page).to have_link('Avaliação', href: feedback_path(feedback, project_proposal_id: proposal))
      expect(page).to have_no_link('Editar')
      expect(page).to have_no_link('Fechar')
      expect(page).to have_no_link('Finalizar')
    end
  end
end
