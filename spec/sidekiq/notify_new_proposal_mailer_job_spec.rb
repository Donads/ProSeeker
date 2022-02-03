require 'rails_helper'

RSpec.describe NotifyNewProposalMailerJob, type: :job do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable 5 }

  it 'should respond to #perform_async' do
    expect(described_class).to respond_to(:perform_async)
  end

  it 'enqueues mailer job' do
    described_class.perform_async(45)

    expect(described_class).to have_enqueued_sidekiq_job(45)
  end
end
