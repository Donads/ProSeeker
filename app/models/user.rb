class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_photo
  has_one :professional_profile
  has_many :projects
  has_many :project_proposals
  has_many :feedbacks_created, class_name: 'Feedback', foreign_key: :feedback_creator_id
  has_many :feedbacks_received, class_name: 'Feedback', foreign_key: :feedback_receiver_id

  enum role: { admin: 0, user: 10, professional: 20 }

  validates :role, presence: true

  def average_score_received?
    feedbacks_received.average(:score)
  end
end
