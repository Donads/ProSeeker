require 'rails_helper'

RSpec.describe Feedback, type: :model do
  context 'validates presence' do
    it 'score must be present' do
      feedback = Feedback.new
      feedback.valid?
      expect(feedback.errors.full_messages_for(:score)).to include('Nota não pode ficar em branco')
    end

    it 'user_feedback must be present' do
      feedback = Feedback.new
      feedback.valid?
      expect(feedback.errors.full_messages_for(:user_feedback)).to include('Avaliação do usuário não pode ficar em branco')
    end

    it 'user_feedback must be present' do
      feedback = Feedback.new
      feedback.valid?
      expect(feedback.errors.full_messages_for(:user_feedback)).to include('Avaliação do usuário não pode ficar em branco')
    end
  end

  context 'project_feedback must be present' do
    it 'when feedback_creator is a professional' do
      feedback = Feedback.new(feedback_creator: User.new(role: :professional))
      feedback.valid?
      expect(feedback.errors.full_messages_for(:project_feedback)).to include('Avaliação do projeto não pode ficar em branco')
    end

    it 'but not when feedback_creator is a an user' do
      feedback = Feedback.new(feedback_creator: User.new(role: :user))
      feedback.valid?
      expect(feedback.errors.full_messages_for(:project_feedback)).to eq []
    end
  end

  context 'feedback can not be made when' do
    it 'project is open' do
      feedback = Feedback.new(project: Project.new(status: :open))
      feedback.valid?
      expect(feedback.errors.full_messages_for(:project_id)).to include('Projeto deve estar finalizado')
    end

    it 'project is closed' do
      feedback = Feedback.new(project: Project.new(status: :closed))
      feedback.valid?
      expect(feedback.errors.full_messages_for(:project_id)).to include('Projeto deve estar finalizado')
    end
  end

  context 'feedback can only be made when' do
    it 'project is finished' do
      feedback = Feedback.new(project: Project.new(status: :finished))
      feedback.valid?
      expect(feedback.errors.full_messages_for(:project_id)).to eq []
    end
  end
end
