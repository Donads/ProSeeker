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
      expect(proposal.errors.full_messages_for(:weekly_hours)).to include('Disponibilidade de horas por semana não pode ficar em branco')
    end

    it 'deadline must be present' do
      proposal = ProjectProposal.new
      proposal.valid?
      expect(proposal.errors.full_messages_for(:deadline)).to include('Expectativa de conclusão não pode ficar em branco')
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
        expect(proposal.errors.full_messages_for(:weekly_hours)).to include('Disponibilidade de horas por semana deve ser maior que 0')
      end

      it 'and was equal to zero' do
        proposal = ProjectProposal.new(weekly_hours: 0)
        proposal.valid?
        expect(proposal.errors.full_messages_for(:weekly_hours)).to include('Disponibilidade de horas por semana deve ser maior que 0')
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
        expect(proposal.errors.full_messages_for(:weekly_hours)).to include('Disponibilidade de horas por semana não é um número inteiro')
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
      expect(proposal.errors.full_messages_for(:deadline)).to include('Expectativa de conclusão não pode estar no passado')
    end

    it 'and was in the present' do
      proposal = ProjectProposal.new(deadline: Date.today)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:deadline)).to include('Expectativa de conclusão não pode estar no passado')
    end

    it 'and was in the future' do
      proposal = ProjectProposal.new(deadline: Date.tomorrow)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:deadline)).to eq []
    end
  end

  context 'hourly_rate must not exceed the maximum allowed for the project' do
    it 'and is greater than the maximum' do
      project = Project.new(max_hourly_rate: 50)
      proposal = ProjectProposal.new(project: project, hourly_rate: 60)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:hourly_rate)).to include('Valor (R$/hora) não pode ser maior que o limite do projeto')
    end

    it 'and is equal to the maximum' do
      project = Project.new(max_hourly_rate: 50)
      proposal = ProjectProposal.new(project: project, hourly_rate: 50)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:hourly_rate)).to eq []
    end

    it 'and is lower than the maximum' do
      project = Project.new(max_hourly_rate: 50)
      proposal = ProjectProposal.new(project: project, hourly_rate: 40)
      proposal.valid?
      expect(proposal.errors.full_messages_for(:hourly_rate)).to eq []
    end
  end
end
