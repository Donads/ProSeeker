class Feedback < ApplicationRecord
  belongs_to :project
  belongs_to :feedback_creator, class_name: 'User'
  belongs_to :feedback_receiver, class_name: 'User'
end
