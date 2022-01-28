class ProjectProposalMailer < ApplicationMailer
  def notify_new_proposal
    @proposal = ProjectProposal.find(params[:proposal])
    @project = @proposal.project

    mail(to: @project.user.email, subject: "Nova proposta para seu projeto #{@project.title}")
  end
end
