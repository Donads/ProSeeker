require 'rails_helper'

describe 'Professional gives feedback to user' do
  context 'after the project is finished' do
    it 'successfully' do
      user = create(:user)
      project = create(:project, user: user)
      professional = create(:user, :professional)
      create(:profile, :profile_2, user: professional)
      create(:proposal, user: professional, project: project, status: :approved)
      project.closed!
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
      expect(page).to have_link("#{user.email} (Nota média: 5.0)", href: received_feedbacks_path(user))
      expect(page).to have_content('Situação: Finalizado')
      expect(page).to have_link('Avaliação', href: feedback_path(feedback))
      expect(page).to have_no_link('Editar')
      expect(page).to have_no_link('Fechar')
      expect(page).to have_no_link('Finalizar')
    end
  end
end
