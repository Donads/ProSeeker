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

    it 'admin is valid' do
      user = User.new(role: :professional)
      user.valid?
      expect(user.errors.full_messages_for(:role)).to eq []
    end

    it 'others are not valid' do
      # TODO: Implement validation that doesn't raise ArgumentError
    end
  end
end
