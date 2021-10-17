require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validates presence' do
    it 'role must be present' do
      user = User.new
      user.valid?
      expect(user.errors.full_messages_for(:role)).to include('Função não pode ficar em branco')
    end
  end

  context 'validates role' do
    it 'user is valid' do
      user = User.new(role: :user)
      user.valid?
      expect(user.errors.full_messages_for(:role)).to eq []
    end

    it 'professional is valid' do
      user = User.new(role: :professional)
      user.valid?
      expect(user.errors.full_messages_for(:role)).to eq []
    end

    it 'admin is not valid on create' do
      user = User.new(role: :admin)
      user.valid?
      expect(user.errors.full_messages_for(:role)).to include('Função não está incluído na lista')
      expect(user.errors.full_messages_for(:role)).to include('Função não está disponível')
    end

    it 'admin is not valid on create' do
      user = User.create!(email: 'admin@admin.com', password: '123456', role: :user)
      user.admin!
      user.valid?
      expect(user.role).to eq 'admin'
      expect(user.errors.full_messages_for(:role)).to eq []
    end
  end
end
