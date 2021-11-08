require 'rails_helper'

describe 'User views project proposals' do
  context 'on their own projects' do
    it 'successfully' do
      user = create(:user)
      project = create(:project, user: user)
      professional_1 = create(:user, :professional)
      profile_1 = create(:profile, user: professional_1)
      professional_2 = create(:user, :professional)
      profile_2 = create(:profile, :profile_2, user: professional_2)
      create(:proposal, user: professional_1, project: project)
      create(:proposal, :proposal_2, user: professional_2, project: project)

      login_as user, scope: :user
      visit root_path
      click_link 'Projetos'
      click_link 'Projeto de E-commerce'

      expect(current_path).to eq project_path(project)
      expect(page).to have_content('Situação: Aberto')
      expect(page).to have_link('Editar', href: edit_project_path(project))
      expect(page).to have_link('Fechar', href: close_project_path(project))
      expect(page).to have_link('Ciclano da Silva', href: professional_profile_path(profile_1))
      expect(page).to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(page).to have_link('Antonio Nunes', href: professional_profile_path(profile_2))
      expect(page).to have_content('Domino o desenvolvimento de projetos web')
      expect(page).to have_button('Aprovar')
      expect(page).to have_link('Rejeitar')
      expect(page).to have_no_link('Finalizar')
    end

    it 'and views the professional profile of the second proposal' do
      user = create(:user)
      project = create(:project, user: user)
      professional_1 = create(:user, :professional)
      create(:profile, user: professional_1)
      professional_2 = create(:user, :professional)
      create(:profile, :profile_2, user: professional_2)
      create(:proposal, project: project, user: professional_1)
      create(:proposal, project: project, user: professional_2)

      login_as user, scope: :user
      visit root_path
      click_link 'Projetos'
      click_link 'Projeto de E-commerce'
      click_link 'Antonio Nunes'

      expect(current_path).to eq professional_profile_path(professional_2.professional_profile)
      expect(page).to have_content('Perfil Profissional')
      expect(page).to have_content('Nome Completo')
      expect(page).to have_content('George Washington')
      expect(page).to have_content('Nome Social')
      expect(page).to have_content('Antonio Nunes')
    end
  end

  context 'on other users projects' do
    it 'and does not see them' do
      user_1 = create(:user)
      user_2 = create(:user)
      project = create(:project, :project_2, user: user_2)
      professional = create(:user, :professional)
      create(:profile, user: professional)
      create(:proposal, :proposal_4, user: professional, project: project)

      login_as user_1, scope: :user
      visit root_path
      click_link 'Projetos'
      click_link 'Desenvolvimento no cliente'

      expect(current_path).to eq project_path(project)
      expect(page).to have_no_content('Propostas enviadas:')
      expect(page).to have_no_content('Ciclano da Silva')
      expect(page).to have_no_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(page).to have_no_content('Antonio Nunes')
      expect(page).to have_no_content('Domino o desenvolvimento de projetos web')
    end
  end

  context 'and accepts a proposal' do
    it 'successfully' do
      user = create(:user)
      project = create(:project, user: user)
      professional_1 = create(:user, :professional)
      profile_1 = create(:profile, user: professional_1)
      professional_2 = create(:user, :professional)
      profile_2 = create(:profile, :profile_2, user: professional_2)
      proposal_1 = create(:proposal, user: professional_1, project: project)
      proposal_2 = create(:proposal, :proposal_2, user: professional_2, project: project)

      login_as user, scope: :user
      visit root_path
      click_link 'Projetos'
      click_link 'Projeto de E-commerce'
      find('tr[project-proposal-id="2"]').click_button('Aprovar')

      expect(current_path).to eq project_path(project)
      expect(page).to have_css('div', text: 'Proposta aprovada com sucesso!')
      expect(proposal_1.reload.status).to eq 'pending'
      expect(proposal_2.reload.status).to eq 'approved'
      expect(page).to have_link('Ciclano da Silva', href: professional_profile_path(profile_1))
      expect(page).to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(page).to have_link('Antonio Nunes', href: professional_profile_path(profile_2))
      expect(page).to have_content('Domino o desenvolvimento de projetos web')
    end
  end

  context 'and rejects a proposal' do
    it 'successfully' do
      user = create(:user)
      project = create(:project, user: user)
      professional_1 = create(:user, :professional)
      profile_1 = create(:profile, user: professional_1)
      professional_2 = create(:user, :professional)
      profile_2 = create(:profile, :profile_2, user: professional_2)
      proposal_1 = create(:proposal, user: professional_1, project: project)
      proposal_2 = create(:proposal, :proposal_2, user: professional_2, project: project)

      login_as user, scope: :user
      visit root_path
      click_link 'Projetos'
      click_link 'Projeto de E-commerce'
      find('tr[project-proposal-id="1"]').click_link('Rejeitar')
      fill_in 'Motivo da Situação', with: 'Baixa disponibilidade de horas para participação no projeto'
      click_button 'Atualizar Proposta'

      expect(current_path).to eq project_path(project)
      expect(page).to have_css('div', text: 'Proposta rejeitada com sucesso!')
      expect(proposal_1.reload.status).to eq 'rejected'
      expect(proposal_2.reload.status).to eq 'pending'
      expect(page).to have_link('Ciclano da Silva', href: professional_profile_path(profile_1))
      expect(page).to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(page).to have_link('Antonio Nunes', href: professional_profile_path(profile_2))
      expect(page).to have_content('Domino o desenvolvimento de projetos web')
    end

    it 'but fails due to not providing a reason' do
      user = create(:user)
      project = create(:project, user: user)
      professional_1 = create(:user, :professional)
      profile_1 = create(:profile, user: professional_1)
      professional_2 = create(:user, :professional)
      create(:profile, :profile_2, user: professional_2)
      proposal_1 = create(:proposal, user: professional_1, project: project)
      proposal_2 = create(:proposal, :proposal_2, user: professional_2, project: project)

      login_as user, scope: :user
      visit root_path
      click_link 'Projetos'
      click_link 'Projeto de E-commerce'
      find('tr[project-proposal-id="1"]').click_link('Rejeitar')
      fill_in 'Motivo da Situação', with: ''
      click_button 'Atualizar Proposta'

      expect(current_path).to eq project_proposal_path(proposal_1)
      expect(page).to have_css('div', text: 'Motivo da Situação não pode ficar em branco')
      expect(page).to have_content("Justifique a rejeição da proposta de #{profile_1.social_name}")
      expect(proposal_1.reload.status).to eq 'pending'
      expect(proposal_2.reload.status).to eq 'pending'
      expect(page).to have_no_content('Proposta rejeitada com sucesso')
    end
  end
end
