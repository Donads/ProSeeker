require 'rails_helper'

RSpec.describe ProfessionalProfile, type: :model do
  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should belong_to(:knowledge_field) }
    it { should have_one_attached(:profile_photo) }
  end

  describe 'presence' do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:social_name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:professional_qualification) }
    it { should validate_presence_of(:professional_experience) }
    it { should validate_presence_of(:birth_date) }
    it { should validate_presence_of(:profile_photo) }
  end

  describe 'uniqueness' do
    subject do
      ProfessionalProfile.new(user: User.create!(email: 'profissional@teste.com.br', password: '123456',
                                                 role: :professional),
                              knowledge_field: KnowledgeField.create!(title: 'Desenvolvedor'))
    end

    it { should validate_uniqueness_of(:user_id).with_message('já possui um perfil cadastrado') }
  end

  describe 'birth_date_must_be_in_the_past' do
    it { should allow_values(Date.yesterday).for(:birth_date) }
    it { should_not allow_values(Date.current).for(:birth_date).with_message('deve estar no passado') }
    it { should_not allow_values(Date.tomorrow).for(:birth_date).with_message('deve estar no passado') }
  end
end
