class CloseProjectsJob
  include Sidekiq::Job

  def perform
    Project.open.where('open_until < :current_date', current_date: Date.current).update(status: :closed)
  end
end
