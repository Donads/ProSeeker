require 'rails_helper'

RSpec.describe KnowledgeField, type: :model do
  describe 'associations' do
    it { should have_many(:professional_profiles) }
  end

  describe 'presence' do
    it { should validate_presence_of(:title) }
  end

  describe 'uniqueness' do
    it { should validate_uniqueness_of(:title).case_insensitive }
  end
end
