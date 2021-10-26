require 'rails_helper'

RSpec.describe ProfessionalProfile, type: :model do
  context 'validates presence' do
    it 'full_name must be present' do
      profile = ProfessionalProfile.new
      profile.valid?
      expect(profile.errors.full_messages_for(:full_name)).to include('Nome Completo não pode ficar em branco')
    end

    it 'social_name must be present' do
      profile = ProfessionalProfile.new
      profile.valid?
      expect(profile.errors.full_messages_for(:social_name)).to include('Nome Social não pode ficar em branco')
    end

    it 'description must be present' do
      profile = ProfessionalProfile.new
      profile.valid?
      expect(profile.errors.full_messages_for(:description)).to include('Descrição não pode ficar em branco')
    end

    it 'professional_qualification must be present' do
      profile = ProfessionalProfile.new
      profile.valid?
      expect(profile.errors.full_messages_for(:professional_qualification)).to include('Qualificação Profissional não pode ficar em branco')
    end

    it 'professional_experience must be present' do
      profile = ProfessionalProfile.new
      profile.valid?
      expect(profile.errors.full_messages_for(:professional_experience)).to include('Experiência Profissional não pode ficar em branco')
    end

    it 'birth_date must be present' do
      profile = ProfessionalProfile.new
      profile.valid?
      expect(profile.errors.full_messages_for(:birth_date)).to include('Data de Nascimento não pode ficar em branco')
    end

    it 'profile_photo must be present' do
      profile = ProfessionalProfile.new
      profile.valid?
      expect(profile.errors.full_messages_for(:profile_photo)).to include('Foto de Perfil não pode ficar em branco')
    end
  end

  context 'birth_date must be in the past' do
    it 'and was in the past' do
      profile = ProfessionalProfile.new(birth_date: Date.yesterday)
      profile.valid?
      expect(profile.errors.full_messages_for(:birth_date)).to eq []
    end

    it 'and was in the present' do
      profile = ProfessionalProfile.new(birth_date: Date.current)
      profile.valid?
      expect(profile.errors.full_messages_for(:birth_date)).to include('Data de Nascimento deve estar no passado')
    end

    it 'and was in the future' do
      profile = ProfessionalProfile.new(birth_date: Date.tomorrow)
      profile.valid?
      expect(profile.errors.full_messages_for(:birth_date)).to include('Data de Nascimento deve estar no passado')
    end
  end

  context 'professional can only have one profile' do
    it 'and tries to create a second one' do
      birth_date = 30.years.ago.to_date
      photo = fixture_file_upload('avatar_placeholder.png', 'image/png')
      knowledge_field = KnowledgeField.create!(title: 'Desenvolvedor')
      professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
      ProfessionalProfile.create!(full_name: 'Fulano de Tal', social_name: 'Ciclano da Silva',
                                  description: 'Busco projetos desafiadores',
                                  professional_qualification: 'Ensino Superior',
                                  professional_experience: '6 anos trabalhando em projetos diversos',
                                  birth_date: birth_date, user: professional, knowledge_field: knowledge_field,
                                  profile_photo: photo)
      new_profile = ProfessionalProfile.new(user: professional)
      new_profile.valid?
      expect(new_profile.errors.full_messages_for(:base)).to include('Perfil já existe pra esse usuário')
    end
  end
end
