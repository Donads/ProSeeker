require 'rails_helper'

describe 'Professional views project team' do
  it 'successfully' do
    user = create(:user)
    project = create(:project, user: user)
    professional_1 = create(:user, :professional)
    profile_1 = create(:profile, user: professional_1)
    professional_2 = create(:user, :professional)
    profile_2 = create(:profile, :profile_2, user: professional_2)
    professional_3 = create(:user, :professional)
    profile_3 = create(:profile, :profile_3, user: professional_3)
    proposal_1 = create(:proposal, user: professional_1, project: project, status: :approved)
    proposal_2 = create(:proposal, :proposal_2, user: professional_2, project: project, status: :rejected)
    proposal_3 = create(:proposal, :proposal_3, user: professional_3, project: project, status: :approved)
    project.closed!

    login_as professional_1, scope: :user
    visit root_path
    click_link 'Meus Projetos'
    click_link 'Projeto de E-commerce'

    expect(current_path).to eq project_path(project)
    expect(proposal_1.reload.status).to eq 'approved'
    expect(proposal_2.reload.status).to eq 'rejected'
    expect(proposal_3.reload.status).to eq 'approved'
    expect(page).to have_content('você enviou a seguinte proposta para esse projeto')
    expect(page).to have_link('Ciclano da Silva', href: professional_profile_path(profile_1))
    expect(page).to have_content('Gosto muito de trabalhar com e-commerces e tenho experiência')
    expect(page).to have_link('Maria Eduarda', href: professional_profile_path(profile_3))
    expect(page).to have_content('Sou especialista em e-commerces')
    expect(page).to have_no_content('Antonio Nunes')
    expect(page).to have_no_content('Domino o desenvolvimento de projetos web')
  end
end
