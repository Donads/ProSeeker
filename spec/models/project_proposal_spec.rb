require 'rails_helper'

RSpec.describe ProjectProposal, type: :model do
  context 'validates presence' do
    it 'reason must be present' do
      proposal = ProjectProposal.new
      proposal.valid?
      expect(proposal.errors.full_messages_for(:reason)).to include('Motivo não pode ficar em branco')
    end

    it 'hourly_rate must be present' do
      proposal = ProjectProposal.new
      proposal.valid?
      expect(proposal.errors.full_messages_for(:hourly_rate)).to include('Valor (R$/hora) não pode ficar em branco')
    end

    it 'weekly_hours must be present' do
      proposal = ProjectProposal.new
      proposal.valid?
      expect(proposal.errors.full_messages_for(:weekly_hours)).to include(
        'Disponibilidade de horas por semana não pode ficar em branco'
      )
    end

    it 'deadline must be present' do
      proposal = ProjectProposal.new
      proposal.valid?
      expect(proposal.errors.full_messages_for(:deadline)).to include(
        'Expectativa de conclusão não pode ficar em branco'
      )
    end
  end

  context 'validates numericality' do
    context 'hourly_rate must be greater than zero' do
      it 'and was lower than zero' do
        proposal = ProjectProposal.new(hourly_rate: -0.1)
        proposal.valid?
        expect(proposal.errors.full_messages_for(:hourly_rate)).to include('Valor (R$/hora) deve ser maior que 0')
      end

      it 'and was equal to zero' do
        proposal = ProjectProposal.new(hourly_rate: 0)
        proposal.valid?
        expect(proposal.errors.full_messages_for(:hourly_rate)).to include('Valor (R$/hora) deve ser maior que 0')
      end

      it 'and was greater than zero' do
        proposal = ProjectProposal.new(hourly_rate: 0.1)
        proposal.valid?
        expect(proposal.errors.full_messages_for(:hourly_rate)).to eq []
      end
    end

    context 'weekly_hours must be greater than zero' do
      it 'and was lower than zero' do
        proposal = ProjectProposal.new(weekly_hours: -1)
        proposal.valid?
        expect(proposal.errors.full_messages_for(:weekly_hours)).to include(
          'Disponibilidade de horas por semana deve ser maior que 0'
        )
      end

      it 'and was equal to zero' do
        proposal = ProjectProposal.new(weekly_hours: 0)
        proposal.valid?
        expect(proposal.errors.full_messages_for(:weekly_hours)).to include(
          'Disponibilidade de horas por semana deve ser maior que 0'
        )
      end

      it 'and was greater than zero' do
        proposal = ProjectProposal.new(weekly_hours: 1)
        proposal.valid?
        expect(proposal.errors.full_messages_for(:weekly_hours)).to eq []
      end
    end

    context 'weekly_hours must be an integer' do
      it 'and was not an integer' do
        proposal = ProjectProposal.new(weekly_hours: 0.5)
        proposal.valid?
        expect(proposal.errors.full_messages_for(:weekly_hours)).to include(
          'Disponibilidade de horas por semana não é um número inteiro'
        )
      end

      it 'and was an integer' do
        proposal = ProjectProposal.new(weekly_hours: 1)
        proposal.valid?
        expect(proposal.errors.full_messages_for(:weekly_hours)).to eq []
      end
    end
  end

  context 'deadline must be in the future' do
    it 'and was in the past' do
      proposal = ProjectProposal.new(deadline: Date.yesterday)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:deadline)).to include(
        'Expectativa de conclusão não pode estar no passado'
      )
    end

    it 'and was in the present' do
      proposal = ProjectProposal.new(deadline: Date.current)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:deadline)).to include(
        'Expectativa de conclusão não pode estar no passado'
      )
    end

    it 'and was in the future' do
      proposal = ProjectProposal.new(deadline: Date.tomorrow)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:deadline)).to eq []
    end
  end

  context 'deadline must be within one year' do
    it 'and was before that' do
      proposal = ProjectProposal.new(deadline: 1.year.from_now - 1.day)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:deadline)).to eq []
    end

    it 'and was after that' do
      proposal = ProjectProposal.new(deadline: 1.year.from_now + 1.day)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:deadline)).to include(
        'Expectativa de conclusão não pode passar de um ano'
      )
    end
  end

  context 'professional can only have one active proposal for each project' do
    it 'and tries to submit a second one' do
      user = User.create!(email: 'usuario@teste.com.br', password: '123456', role: :user)
      professional = User.create!(email: 'profissional@teste.com.br', password: '123456', role: :professional)
      project = Project.new(open_until: Date.tomorrow, attendance_type: :mixed_attendance, user: user)
      project.save(validate: false)
      proposal1 = ProjectProposal.new(project: project, user: professional)
      proposal1.save(validate: false)

      proposal2 = ProjectProposal.new(project: project, user: professional)
      proposal2.valid?

      expect(proposal2.errors.full_messages_for(:base)).to include('Proposta já existe pra esse projeto')
    end
  end

  context 'proposal must be done while project is open' do
    it 'and was done after the closing day' do
      project = Project.new(open_until: Date.yesterday)
      proposal = ProjectProposal.new(project: project)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:project_id)).to include('Projeto não está aberto')
    end

    it 'and was done during the closing day' do
      project = Project.new(open_until: Date.current)
      proposal = ProjectProposal.new(project: project)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:project_id)).to eq []
    end

    it 'and was done before the closing day' do
      project = Project.new(open_until: Date.tomorrow)
      proposal = ProjectProposal.new(project: project)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:project_id)).to eq []
    end

    it 'and was done when open' do
      project = Project.new(open_until: Date.tomorrow, status: :open)
      proposal = ProjectProposal.new(project: project)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:project_id)).to eq []
    end

    it 'and was done when closed' do
      project = Project.new(open_until: Date.tomorrow, status: :closed)
      proposal = ProjectProposal.new(project: project)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:project_id)).to include('Projeto não está aberto')
    end

    it 'and was done when finished' do
      project = Project.new(open_until: Date.tomorrow, status: :finished)
      proposal = ProjectProposal.new(project: project)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:project_id)).to include('Projeto não está aberto')
    end
  end

  context 'hourly_rate must not exceed the maximum allowed for the project' do
    before :context do
      @project = Project.new(max_hourly_rate: 50, open_until: Date.tomorrow)
    end

    it 'and is greater than the maximum' do
      proposal = ProjectProposal.new(project: @project, hourly_rate: 60)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:hourly_rate)).to include(
        'Valor (R$/hora) não pode ser maior que o limite do projeto'
      )
    end

    it 'and is equal to the maximum' do
      proposal = ProjectProposal.new(project: @project, hourly_rate: 50)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:hourly_rate)).to eq []
    end

    it 'and is lower than the maximum' do
      proposal = ProjectProposal.new(project: @project, hourly_rate: 40)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:hourly_rate)).to eq []
    end
  end

  context 'professional tries to cancel proposal' do
    it '2 days after it was approved' do
      proposal = ProjectProposal.new(status: :approved)
      proposal.status_date = 2.days.ago
      proposal.valid?(:destroy)
      expect(proposal.errors.full_messages_for(:status)).to eq []
    end

    it '3 days after it was approved' do
      proposal = ProjectProposal.new(status: :approved)
      proposal.status_date = 3.days.ago + 1.minute
      proposal.valid?(:destroy)
      expect(proposal.errors.full_messages_for(:status)).to eq []
    end

    it '3 days after it was approved' do
      proposal = ProjectProposal.new(status: :approved)
      proposal.status_date = 3.days.ago - 1.minute
      proposal.valid?(:destroy)
      expect(proposal.errors.full_messages_for(:status)).to include('Situação da proposta não permite cancelamento')
    end

    it '4 days after it was approved' do
      proposal = ProjectProposal.new(status: :approved)
      proposal.status_date = 4.days.ago
      proposal.valid?(:destroy)
      expect(proposal.errors.full_messages_for(:status)).to include('Situação da proposta não permite cancelamento')
    end

    it 'when it is pending' do
      proposal = ProjectProposal.new(status: :pending)
      proposal.status_date = 10.days.ago
      proposal.valid?(:destroy)
      expect(proposal.errors.full_messages_for(:status)).to eq []
    end

    it 'when it was rejected' do
      proposal = ProjectProposal.new(status: :rejected)
      proposal.status_date = 10.days.ago
      proposal.valid?(:destroy)
      expect(proposal.errors.full_messages_for(:status)).to eq []
    end

    it 'when it was rated' do
      proposal = ProjectProposal.new(status: :rated)
      proposal.status_date = 10.days.ago
      proposal.valid?(:destroy)
      expect(proposal.errors.full_messages_for(:status)).to include('Situação da proposta não permite cancelamento')
    end
  end

  context 'user tries to reject proposal' do
    it 'with status_reason filled and succeeds' do
      proposal = ProjectProposal.new(status: :rejected, status_reason: 'Motivo da rejeição')
      proposal.valid?(:reject)
      expect(proposal.errors.full_messages_for(:status_reason)).to eq []
    end

    it 'with status_reason empty and fails' do
      proposal = ProjectProposal.new(status: :rejected, status_reason: '')
      proposal.valid?(:reject)
      expect(proposal.errors.full_messages_for(:status_reason)).to include('Motivo da Situação não pode ficar em branco')
    end
  end
end
