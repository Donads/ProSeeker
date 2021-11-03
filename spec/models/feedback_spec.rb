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

  describe 'check_related_users' do
    context 'from_user' do
      subject { build(:feedback, feedback_creator: build(:user), feedback_receiver: build(:user, :professional)) }

      it {
        subject.valid?
        expect(subject.errors.full_messages_for(:feedback_creator_id)).to include('Avaliador diferente do criador do projeto')
      }
      it {
        subject.valid?
        expect(subject.errors.full_messages_for(:feedback_receiver_id)).to include('Avaliado diferente do criador da proposta')
      }
    end

    context 'from_professional' do
      subject do
        build(:feedback, :from_professional, feedback_creator: build(:user, :professional),
                                             feedback_receiver: build(:user))
      end

      it {
        subject.valid?
        expect(subject.errors.full_messages_for(:feedback_creator_id)).to include('Avaliador diferente do criador da proposta')
      }
      it {
        subject.valid?
        expect(subject.errors.full_messages_for(:feedback_receiver_id)).to include('Avaliado diferente do criador do projeto')
      }
    end
  end

  describe 'professional_must_fill_project_feedback' do
    subject { build(:feedback, :from_professional) }

    it { should validate_presence_of(:project_feedback) }
  end

  describe 'user_can_not_fill_project_feedback' do
    subject { build(:feedback) }

    it { should_not allow_value('abc').for(:project_feedback) }
  end

  describe 'check_project_status' do
    subject do
      project = build(:project, status: status)
      project_proposal = build(:proposal, project: project)
      build(:feedback, project_proposal: project_proposal)
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
