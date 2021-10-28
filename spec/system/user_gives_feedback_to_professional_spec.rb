require 'rails_helper'

describe 'User gives feedback to professional' do
  context 'after the project is finished' do
    it 'successfully' do
      user = create(:user)
      project = create(:project, user: user)
      professional_1 = create(:user, :professional)
      profile_1 = create(:profile, user: professional_1)
      professional_2 = create(:user, :professional)
      profile_2 = create(:profile, :profile_2, user: professional_2)
      proposal_1 = create(:proposal, user: professional_1, project: project, status: :approved)
      proposal_2 = create(:proposal, :proposal_2, user: professional_2, project: project, status: :approved)
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

      generated_feedback = Feedback.last
      expect(current_path).to eq project_path(project)
      expect(page).to have_css('div', text: 'Avaliação enviada com sucesso!')
      expect(proposal_1.reload.status).to eq 'approved'
      expect(proposal_2.reload.status).to eq 'rated'
      expect(professional_2.reload.average_score_received?).to eq feedback[:score]
      expect(page).to have_content('Situação: Finalizado')
      expect(page).to have_link('Ciclano da Silva', href: professional_profile_path(profile_1))
      expect(page).to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(page).to have_link('Antonio Nunes', href: professional_profile_path(profile_2))
      expect(page).to have_content('Domino o desenvolvimento de projetos web')
      expect(page).to have_link('Avaliar', href: new_feedback_path(project_proposal_id: proposal_1))
      expect(page).to have_link('Avaliação', href: feedback_path(generated_feedback))
      expect(page).to have_no_link('Editar')
      expect(page).to have_no_link('Fechar')
      expect(page).to have_no_link('Finalizar')
    end
  end
end
