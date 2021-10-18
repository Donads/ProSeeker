namespace :dev do
  desc 'Populates the database with records for testing'
  task populate_database: :environment do
    if Rails.env.development?
      puts "Criando Áreas de Conhecimento\n"
      `rails dev:create_knowledge_fields`
      puts "Criando Usuários\n"
      `rails dev:create_users`
      puts "Criando Perfis Profissionais\n"
      `rails dev:create_professional_profiles`
      puts "Criando Projetos\n"
      `rails dev:create_projects`
      puts "Criando Propostas de Projetos\n"
      `rails dev:create_project_proposals`
    else
      puts 'Você não está em ambiente de desenvolvimento!'
    end
  end

  desc 'Creates some records for the KnowledgeField model'
  task create_knowledge_fields: :environment do
    knowledge_fields = [
      { title: 'Administrador de Banco de Dados' },
      { title: 'Analista de Qualidade' },
      { title: 'Desenvolvedor Back-End' },
      { title: 'Desenvolvedor Front-End' },
      { title: 'Desenvolvedor Full Stack' },
      { title: 'UX Designer' }
    ]

    knowledge_fields.each { |knowledge_field| KnowledgeField.find_or_create_by!(knowledge_field) }
  end

  desc 'Creates some users with varying roles'
  task create_users: :environment do
    users = [
      { email: 'admin@teste.com.br', password: '123456', role: 'user' },
      { email: 'usuario1@teste.com.br', password: '123456', role: 'user' },
      { email: 'usuario2@teste.com.br', password: '123456', role: 'user' },
      { email: 'usuario3@teste.com.br', password: '123456', role: 'user' },
      { email: 'profissional1@teste.com.br', password: '123456', role: 'professional' },
      { email: 'profissional2@teste.com.br', password: '123456', role: 'professional' },
      { email: 'profissional3@teste.com.br', password: '123456', role: 'professional' }
    ]
    users.each { |user| User.create!(user) }

    admin = User.find_by(email: 'admin@teste.com.br')
    admin.admin!
  end

  desc 'Creates some records for the KnowledgeField model'
  task create_professional_profiles: :environment do
    professional_1 = User.find_by(email: 'profissional1@teste.com.br')
    professional_2 = User.find_by(email: 'profissional2@teste.com.br')
    professional_3 = User.find_by(email: 'profissional3@teste.com.br')
    knowledge_field_1 = KnowledgeField.find_by(title: 'Desenvolvedor Full Stack')
    knowledge_field_2 = KnowledgeField.find_by(title: 'Desenvolvedor Full Stack')
    knowledge_field_3 = KnowledgeField.find_by(title: 'Desenvolvedor Back-End')
    birth_date = 40.years.ago

    professional_profiles = [
      { full_name: 'João da Silva', social_name: 'João da Silva', description: 'Essa é a descrição do meu perfil',
        birth_date: birth_date, professional_qualification: 'Essas são minhas qualificações profissionais',
        professional_experience: 'Essa é minha experiência profissional', knowledge_field: knowledge_field_1, user: professional_1 },
      { full_name: 'Alessando Oliveira', social_name: 'Marcia Oliveira', description: 'Essa é a descrição do meu perfil',
        birth_date: birth_date, professional_qualification: 'Essas são minhas qualificações profissionais',
        professional_experience: 'Essa é minha experiência profissional', knowledge_field: knowledge_field_2, user: professional_2 },
      { full_name: 'Maria Eduarda', social_name: 'Maria Eduarda', description: 'Essa é a descrição do meu perfil',
        birth_date: birth_date, professional_qualification: 'Essas são minhas qualificações profissionais',
        professional_experience: 'Essa é minha experiência profissional', knowledge_field: knowledge_field_3, user: professional_3 }
    ]

    professional_profiles.each do |profile|
      new_profile = ProfessionalProfile.new(profile)
      new_profile.save(validate: false) # Ignores validation for profile photo
    end
  end

  desc 'Creates some records for the Project model'
  task create_projects: :environment do
    user_1 = User.find_by(email: 'usuario1@teste.com.br')
    user_2 = User.find_by(email: 'usuario2@teste.com.br')
    user_3 = User.find_by(email: 'usuario3@teste.com.br')
    professional_1 = User.find_by(email: 'profissional1@teste.com.br')
    professional_2 = User.find_by(email: 'profissional2@teste.com.br')
    professional_3 = User.find_by(email: 'profissional3@teste.com.br')
    future_date = 20.days.from_now

    projects = [
      { title: 'Desenvolvimento de API', description: 'Desenvolver APIs para integração de sistemas internos',
        skills: 'Experiência com APIs', max_hourly_rate: 0.55e2, open_until: future_date,
        attendance_type: 'mixed_attendance', user: user_1, status: 'open' },
      { title: 'Desenvolvimento no cliente', description: 'Desenvolver customizações em sistema',
        skills: 'Comunicação e regras de negócio', max_hourly_rate: 0.5e2, open_until: future_date,
        attendance_type: 'presential_attendance', user: user_2, status: 'open' },
      { title: 'Projeto de E-commerce', description: 'Desenvolver plataforma web', skills: 'Ruby on Rails',
        max_hourly_rate: 0.85e2, open_until: future_date, attendance_type: 'remote_attendance', user: user_1, status: 'open' },
      { title: 'Sistema ERP', description: 'Desenvolvimento de sistema ERP', skills: 'Conhecimento de regras de negócio',
        max_hourly_rate: 0.1e3, open_until: future_date, attendance_type: 'remote_attendance', user: user_1, status: 'open' }
    ]
    projects.each { |project| Project.find_or_create_by!(project) }
  end

  desc 'Creates some records for the ProjectProposal model'
  task create_project_proposals: :environment do
    project_1 = Project.find_by(title: 'Desenvolvimento de API')
    project_2 = Project.find_by(title: 'Desenvolvimento no cliente')
    project_3 = Project.find_by(title: 'Projeto de E-commerce')
    professional_1 = User.find_by(email: 'profissional1@teste.com.br')
    professional_2 = User.find_by(email: 'profissional2@teste.com.br')
    professional_3 = User.find_by(email: 'profissional3@teste.com.br')
    future_date = 40.days.from_now

    project_proposals = [
      { reason: 'Muita experiência', hourly_rate: 0.25e2, weekly_hours: 20, deadline: future_date, project: project_1,
        user: professional_1, status: 'pending', status_reason: '' },
      { reason: 'Minha área favorita', hourly_rate: 0.28e2, weekly_hours: 25, deadline: future_date, project: project_1,
        user: professional_2, status: 'pending', status_reason: '' },
      { reason: 'Busco desafios', hourly_rate: 0.3e2, weekly_hours: 30, deadline: future_date, project: project_1,
        user: professional_3, status: 'pending', status_reason: '' },
      { reason: 'Desejo agregar ao time', hourly_rate: 0.4e2, weekly_hours: 30, deadline: future_date,
        project: project_2, user: professional_1, status: 'pending', status_reason: '' }
    ]
    project_proposals.each { |proposal| ProjectProposal.find_or_create_by!(proposal) }
  end
end
