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
  end
end
