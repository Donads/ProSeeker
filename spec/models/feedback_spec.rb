require 'rails_helper'

RSpec.describe Feedback, type: :model do
  describe 'associations' do
    it { should belong_to(:project_proposal) }
    it { should belong_to(:feedback_creator).class_name('User') }
    it { should belong_to(:feedback_receiver).class_name('User') }
  end

  describe 'define_enum' do
    it { should define_enum_for(:feedback_source).with_values(from_user: 10, from_professional: 20) }
  end

  describe 'presence' do
    it { should validate_presence_of(:score) }
    it { should validate_presence_of(:user_feedback) }
  end

  describe 'numericality' do
    it {
      should validate_numericality_of(:score).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5)
    }
  end

  describe 'professional_must_fill_project_feedback' do
    subject { Feedback.new(feedback_creator: User.new(role: :professional)) }

    it { should validate_presence_of(:project_feedback) }
  end

  describe 'user_can_not_fill_project_feedback' do
    subject { Feedback.new(feedback_creator: User.new(role: :user)) }

    it { should_not allow_value('abc').for(:project_feedback) }
  end

  describe 'check_project_status' do
    subject do
      project = Project.new(status: status)
      project_proposal = ProjectProposal.new(project: project)
      Feedback.new(project_proposal: project_proposal)
    end

    context 'when project is open' do
      let(:status) { :open }

      it {
        subject.valid?
        expect(subject.errors.full_messages_for(:project_proposal_id)).to include('Proposta deve pertencer a um projeto finalizado')
      }
    end

    context 'when project is closed' do
      let(:status) { :closed }

      it {
        subject.valid?
        expect(subject.errors.full_messages_for(:project_proposal_id)).to include('Proposta deve pertencer a um projeto finalizado')
      }
    end

    context 'when project is finished' do
      let(:status) { :finished }

      it {
        subject.valid?
        expect(subject.errors.full_messages_for(:project_proposal_id)).to eq []
      }
    end
  end
end
