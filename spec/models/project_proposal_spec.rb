require 'rails_helper'

RSpec.describe ProjectProposal, type: :model do
  # TODO: Adicionar validações e tratar testes (datas automaticas), além da validar com informações do projeto (preço maximo)
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
end
