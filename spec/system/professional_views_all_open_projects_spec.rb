require 'rails_helper'

describe 'Professional views all open projects' do
  it 'successfully' do
    professional = create(:user, :professional)
    create(:profile, user: professional)
    user = create(:user)
    project_1 = create(:project, user: user)
    project_2 = create(:project, :project_2, user: user)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'

    expect(current_path).to eq projects_path
    expect(page).to have_link('Projeto de E-commerce', href: project_path(project_1))
    expect(page).to have_link('Desenvolvimento no cliente', href: project_path(project_2))
  end

  it 'and filters by title or description' do
    professional = create(:user, :professional)
    create(:profile, user: professional)
    user = create(:user)
    project_1 = create(:project, user: user)
    create(:project, :project_2, user: user)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'
    fill_in :query, with: 'web'
    click_button 'Buscar'

    expect(current_path).to eq projects_path
    expect(page).to have_link('Projeto de E-commerce', href: project_path(project_1))
    expect(page).to have_no_link('Desenvolvimento no cliente')
  end
end
