require 'rails_helper'

RSpec.describe ProjectProposalMailer, type: :mailer do
  context 'new proposal' do
    it 'notifies project creator' do
      project = create(:project)
      proposal = create(:proposal, project: project,
                                   reason: 'Gosto muito de trabalhar com e-commerces e tenho experiência',
                                   hourly_rate: 70, weekly_hours: 30, deadline: 2.months.from_now.to_date)
      create(:professional_profile, user: proposal.user)

      mail = ProjectProposalMailer.with(proposal: proposal.id).notify_new_proposal

      expect(mail.to).to eq [project.user.email]
      expect(mail.from).to eq ['proseeker@yandonadi.dev']
      expect(mail.subject).to eq "Nova proposta para seu projeto #{project.title}"
      expect(mail.body).to include("Olá, #{proposal.user.professional_profile.social_name}" \
                                   ' enviou a seguinte proposta para seu projeto:')
      expect(mail.body).to include('Motivo: Gosto muito de trabalhar com e-commerces e tenho experiência')
      expect(mail.body).to include('Valor (R$/hora): R$ 70,00')
      expect(mail.body).to include('Disponibilidade de horas por semana: 30')
      expect(mail.body).to include("Expectativa de conclusão: #{I18n.localize(proposal.deadline)}")
      expect(mail.body).to include("Data da Situação: #{I18n.localize(proposal.status_date)}")
    end
  end
end
