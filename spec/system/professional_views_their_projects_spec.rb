require 'rails_helper'

describe 'Professional views their projects' do
  it 'successfully' do
    user = create(:user)
    project_1 = create(:project, user: user)
    project_2 = create(:project, :project_2, user: user)
    professional = create(:user, :professional)
    create(:profile, user: professional)
    create(:proposal, project: project_1, user: professional, status: :approved)
    create(:proposal, project: project_2, user: professional, status: :approved)
    project_1.closed!
    project_2.finished!

    login_as professional, scope: :user
    visit root_path
    click_link 'Meus Projetos'

    expect(current_path).to eq my_projects_projects_path
    expect(page).to have_link('Projeto de E-commerce', href: project_path(project_1))
    expect(page).to have_link('Desenvolvimento no cliente', href: project_path(project_2))
  end

  it 'and filters by title or description' do
    user = create(:user)
    project_1 = create(:project, user: user)
    project_2 = create(:project, :project_2, user: user)
    professional = create(:user, :professional)
    create(:profile, user: professional)
    create(:proposal, project: project_1, user: professional, status: :approved)
    create(:proposal, project: project_2, user: professional, status: :approved)
    project_1.closed!
    project_2.finished!

    login_as professional, scope: :user
    visit root_path
    click_link 'Meus Projetos'
    fill_in :query, with: 'customi'
    click_button 'Buscar'

    expect(current_path).to eq my_projects_projects_path
    expect(page).to have_no_link('Projeto de E-commerce')
    expect(page).to have_link('Desenvolvimento no cliente', href: project_path(project_2))
  end
end
