require 'rails_helper'

describe 'User marks project as closed' do
  context 'with approved proposals' do
    it 'successfully' do
      user = create(:user)
      project = create(:project, user: user)
      professional_1 = create(:user, :professional)
      profile_1 = create(:profile, user: professional_1)
      professional_2 = create(:user, :professional)
      profile_2 = create(:profile, :profile_2, user: professional_2)
      create(:proposal, user: professional_1, project: project, status: :approved)
      create(:proposal, :proposal_2, user: professional_2, project: project, status: :approved)

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
