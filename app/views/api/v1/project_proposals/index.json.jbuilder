json.data do
  json.project_proposals(@project_proposals) do |proposal|
    json.id proposal.id
    json.reason proposal.reason
    json.status proposal.status
    json.status_reason proposal.status_reason
    json.user_id proposal.project.user.id
    json.user_email proposal.project.user.email
    if proposal.project.user.average_score_received? > 0
      json.user_average_score proposal.project.user.average_score_received?
    end

    json.professional do
      json.id proposal.user.id
      json.email proposal.user.email
      json.name proposal.user.professional_profile.social_name
      json.average_score proposal.user.average_score_received? if proposal.user.average_score_received? > 0
    end

    json.project proposal.project, :id, :title, :status

    json.feedbacks do
      json.from_user do
        json.array! proposal.feedbacks.from_user, :id, :score, :user_feedback
      end

      json.from_professional do
        json.array! proposal.feedbacks.from_professional, :id, :score, :user_feedback, :project_feedback
      end
    end
  end
end
