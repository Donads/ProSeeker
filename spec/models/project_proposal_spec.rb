require 'rails_helper'

RSpec.describe ProjectProposal, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
    it { should have_many(:feedbacks) }
  end

  describe 'define_enum' do
    it { should define_enum_for(:status).with_values(pending: 10, approved: 20, rejected: 30, rated: 40, canceled: 90) }
  end

  describe 'presence' do
    it { should validate_presence_of(:reason) }
    it { should validate_presence_of(:hourly_rate) }
    it { should validate_presence_of(:weekly_hours) }
    it { should validate_presence_of(:deadline) }
    it { should validate_presence_of(:status_reason).on(:cancel) }
    it { should validate_presence_of(:status_reason).on(:reject) }
  end

  describe 'numericality' do
    it { should validate_numericality_of(:hourly_rate).is_greater_than(0) }
    it { should validate_numericality_of(:weekly_hours).only_integer.is_greater_than(0) }
  end

  describe 'uniqueness' do
    subject do
      user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
      professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
      project = Project.new(open_until: Date.tomorrow, attendance_type: :mixed_attendance, user: user)
      project.save(validate: false)
      ProjectProposal.new(project: project, user: professional)
    end

    it {
      should validate_uniqueness_of(:user_id).scoped_to(:project_id).with_message('já possui proposta para esse projeto')
    }
  end

  describe 'deadline_cannot_be_in_the_past' do
    it { should_not allow_values(Date.yesterday).for(:deadline) }
    it { should_not allow_values(Date.current).for(:deadline) }
    it { should allow_values(Date.tomorrow).for(:deadline) }
  end

  describe 'deadline_must_be_within_limit' do
    it { should allow_values(1.year.from_now - 1.day).for(:deadline) }
    it { should_not allow_values(1.year.from_now + 1.day).for(:deadline) }
  end

  describe 'check_project_status' do
    subject { ProjectProposal.new(project: project) }

    context 'validate project date' do
      let(:project) { Project.new(open_until: open_until) }

      context 'proposal was done after the closing day' do
        let(:open_until) { Date.yesterday }

        it { should validate_presence_of(:project_id).with_message('não está aberto') }
      end

      context 'proposal was done after the closing day' do
        let(:open_until) { Date.current }

        it { should_not validate_presence_of(:project_id).with_message('não está aberto') }
      end

      context 'proposal was done after the closing day' do
        let(:open_until) { Date.tomorrow }

        it { should_not validate_presence_of(:project_id).with_message('não está aberto') }
      end
    end

    context 'validate project status' do
      let(:project) { Project.new(open_until: Date.tomorrow, status: status) }

      context 'when project is open' do
        let(:status) { :open }

        it { should_not validate_presence_of(:project_id).with_message('não está aberto') }
      end

      context 'when project is closed' do
        let(:status) { :closed }

        it { should validate_presence_of(:project_id).with_message('não está aberto') }
      end

      context 'when project is finished' do
        let(:status) { :finished }

        it { should validate_presence_of(:project_id).with_message('não está aberto') }
      end
    end
  end

  describe 'hourly_rate_cannot_exceed_maximum_allowed' do
    subject do
      project = Project.new(max_hourly_rate: 50, open_until: Date.tomorrow)
      ProjectProposal.new(project: project)
    end

    it { should_not allow_values(50.1).for(:hourly_rate).with_message('não pode ser maior que o limite do projeto') }
    it { should allow_values(50.0).for(:hourly_rate) }
    it { should allow_values(49.9).for(:hourly_rate) }
  end

  context 'can_not_be_canceled' do
    context 'validate status_date' do
      subject { ProjectProposal.new(status: :approved) }

      it '2 days after it was approved' do
        should allow_values(2.days.ago).for(:status_date).on(:destroy)
      end
      it '3 days after it was approved' do
        should allow_values(3.days.ago + 1.minute).for(:status_date).on(:destroy)
      end
      it '3 days after it was approved' do
        should_not allow_values(3.days.ago - 1.minute).for(:status_date).on(:destroy).with_message('da proposta não permite cancelamento')
      end
      it '4 days after it was approved' do
        should_not allow_values(4.days.ago).for(:status_date).on(:destroy).with_message('da proposta não permite cancelamento')
      end
    end

    context 'validate project status' do
      subject { ProjectProposal.new(status_date: 10.days.ago) }

      it { should allow_values(:pending).for(:status).on(:destroy) }
      it { should allow_values(:rejected).for(:status).on(:destroy) }
      it {
        should_not allow_values(:rated).for(:status).on(:destroy).with_message('da proposta não permite cancelamento')
      }
    end
  end
end
