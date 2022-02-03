require 'rails_helper'

RSpec.describe CloseProjectsJob, type: :job do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it 'should respond to #perform_at' do
    expect(described_class).to respond_to(:perform_at)
  end

  it 'should respond to #perform_async' do
    expect(described_class).to respond_to(:perform_async)
  end

  it 'enqueues close_projects_job at midnight' do
    described_class.perform_at(Date.tomorrow.midnight)

    expect(described_class).to have_enqueued_sidekiq_job.at(Date.tomorrow.midnight)
    expect(described_class.jobs.size).to be 1
  end

  it 'enqueues close_projects_job' do
    described_class.perform_async

    expect(described_class).to have_enqueued_sidekiq_job
    expect(described_class.jobs.size).to be 1
  end

  it "ensures that the job closes projects according to 'open_until'" do
    project_1 = create(:project, title: 'Projeto a ser fechado', open_until: 10.days.from_now)
    project_2 = create(:project, title: 'Projeto que continuará aberto', open_until: 20.days.from_now)
    travel 15.days do
      described_class.perform_async
      described_class.drain
    end

    expect(project_1.reload).to be_closed
    expect(project_2.reload).to be_open
  end
end
