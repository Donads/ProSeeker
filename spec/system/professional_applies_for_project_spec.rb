require 'rails_helper'

describe 'Professional applies for project' do
  it 'successfully' do
    professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: '1990-12-31', user: professional)
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                    skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: '31/12/2021',
                    attendance_type: :remote_attendance, user: user)
    Project.create!(title: 'Desenvolvimento no cliente', description: 'Desenvolver customizações em sistema',
                    skills: 'Comunicação e regras de negócio', max_hourly_rate: 50, open_until: '25/12/2021',
                    attendance_type: :presential_attendance, user: user)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'
    click_link 'Projeto de E-commerce'
    within 'form' do
      fill_in 'Motivo', with: 'Gosto muito de trabalhar com e-commerces e tenho experiência'
      fill_in 'Valor (R$/hora)', with: 70.0
      fill_in 'Disponibilidade de horas por semana', with: 30
      fill_in 'Expectativa de conclusão', with: '20/02/2022'
      click_button 'Criar Proposta'
    end

    expect(page).to have_css('div', text: 'Proposta enviada com sucesso!')
    expect(page).to have_content('Ciclano da Silva, você enviou a seguinte proposta para esse projeto:')
    expect(page).to have_field('Motivo', with: 'Gosto muito de trabalhar com e-commerces e tenho experiência')
    expect(page).to have_field('Valor (R$/hora)', with: 70.0)
    expect(page).to have_field('Disponibilidade de horas por semana', with: 30)
    expect(page).to have_field('Expectativa de conclusão', with: '2022-02-20')
  end

  it 'and edits it successfully' do
    professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
    ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                description: 'Busco projetos desafiadores',
                                professional_qualification: 'Ensino Superior',
                                professional_experience: '6 anos trabalhando em projetos diversos',
                                birth_date: '1990-12-31', user: professional)
    user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
    project = Project.create!(title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web',
                              skills: 'Ruby on Rails', max_hourly_rate: 80, open_until: '31/12/2021',
                              attendance_type: :remote_attendance, user: user)
    ProjectProposal.create!(reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                            hourly_rate: 70.0, weekly_hours: 30, deadline: '2022-02-20', project: project,
                            user: professional)

    login_as professional, scope: :user
    visit root_path
    click_link 'Projetos'
    click_link 'Projeto de E-commerce'
    within 'form' do
      fill_in 'Valor (R$/hora)', with: 65.8
      fill_in 'Expectativa de conclusão', with: '23/02/2022'
      click_button 'Atualizar Proposta'
    end

    expect(page).to have_css('div', text: 'Proposta atualizada com sucesso!')
    expect(page).to have_content('Ciclano da Silva, você enviou a seguinte proposta para esse projeto:')
    expect(page).to have_field('Motivo', with: 'Gosto muito de trabalhar com e-commerces e tenho experiência')
    expect(page).to have_field('Valor (R$/hora)', with: 65.8)
    expect(page).to have_field('Disponibilidade de horas por semana', with: 30)
    expect(page).to have_field('Expectativa de conclusão', with: '2022-02-23')
  end
end
