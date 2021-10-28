require 'rails_helper'

describe 'User marks project as finished' do
  context 'with approved proposals' do
    it 'successfully' do
      user = create(:user)
      project = create(:project, user: user)
      professional_1 = create(:user, :professional)
      profile_1 = create(:profile, user: professional_1)
      professional_2 = create(:user, :professional)
      profile_2 = create(:profile, :profile_2, user: professional_2)
      proposal_1 = create(:proposal, user: professional_1, project: project, status: :approved)
      proposal_2 = create(:proposal, :proposal_2, user: professional_2, project: project, status: :approved)
      project.closed!

      login_as user, scope: :user
      visit root_path
      click_link 'Meus Projetos'
      click_link 'Projeto de E-commerce'
      click_link 'Finalizar'

      expect(current_path).to eq project_path(project)
      expect(page).to have_content('Situação: Finalizado')
      expect(page).to have_link('Ciclano da Silva', href: professional_profile_path(profile_1))
      expect(page).to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(page).to have_link('Antonio Nunes', href: professional_profile_path(profile_2))
      expect(page).to have_content('Domino o desenvolvimento de projetos web')
      expect(page).to have_link('Avaliar', href: new_feedback_path(project_proposal_id: proposal_1))
      expect(page).to have_link('Avaliar', href: new_feedback_path(project_proposal_id: proposal_2))
      expect(page).to have_no_link('Editar')
      expect(page).to have_no_link('Fechar')
      expect(page).to have_no_link('Finalizar')
    end
  end
end
