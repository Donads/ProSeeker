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

  context 'validates numericality' do
    context 'score must be an integer' do
      it 'and is' do
        feedback = Feedback.new(score: 2)
        feedback.valid?
        expect(feedback.errors.full_messages_for(:score)).to eq []
      end

      it 'and is not' do
        feedback = Feedback.new(score: 2.5)
        feedback.valid?
        expect(feedback.errors.full_messages_for(:score)).to include('Nota não é um número inteiro')
      end
    end

    context 'score must be in range 1..5' do
      it '0 is not valid' do
        feedback = Feedback.new(score: 0)
        feedback.valid?
        expect(feedback.errors.full_messages_for(:score)).to include('Nota deve ser maior ou igual a 1')
      end

      it '1 is valid' do
        feedback = Feedback.new(score: 1)
        feedback.valid?
        expect(feedback.errors.full_messages_for(:score)).to eq []
      end

      it '2 is valid' do
        feedback = Feedback.new(score: 2)
        feedback.valid?
        expect(feedback.errors.full_messages_for(:score)).to eq []
      end

      it '4 is valid' do
        feedback = Feedback.new(score: 4)
        feedback.valid?
        expect(feedback.errors.full_messages_for(:score)).to eq []
      end

      it '5 is valid' do
        feedback = Feedback.new(score: 5)
        feedback.valid?
        expect(feedback.errors.full_messages_for(:score)).to eq []
      end

      it '6 is not valid' do
        feedback = Feedback.new(score: 6)
        feedback.valid?
        expect(feedback.errors.full_messages_for(:score)).to include('Nota deve ser menor ou igual a 5')
      end
    end
  end

  context 'project_feedback must be present' do
    it 'when feedback_creator is a professional' do
      feedback = Feedback.new(project_feedback: '', feedback_creator: User.new(role: :professional))
      feedback.valid?
      expect(feedback.errors.full_messages_for(:project_feedback)).to include('Avaliação do projeto não pode ficar em branco')
    end

    it 'when feedback_creator is a professional' do
      feedback = Feedback.new(project_feedback: 'testing', feedback_creator: User.new(role: :professional))
      feedback.valid?
      expect(feedback.errors.full_messages_for(:project_feedback)).to eq []
    end

    it 'but not when feedback_creator is a an user' do
      feedback = Feedback.new(project_feedback: '', feedback_creator: User.new(role: :user))
      feedback.valid?
      expect(feedback.errors.full_messages_for(:project_feedback)).to eq []
    end

    it 'but not when feedback_creator is a an user' do
      feedback = Feedback.new(project_feedback: 'testing', feedback_creator: User.new(role: :user))
      feedback.valid?
      expect(feedback.errors.full_messages_for(:project_feedback)).to include('Avaliação do projeto não pode ser preenchido')
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
