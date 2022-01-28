class NotifyNewProposalMailerJob
  include Sidekiq::Job

  def perform(project_proposal)
    ProjectProposalMailer.with(proposal: project_proposal).notify_new_proposal.deliver_now
  end
end
