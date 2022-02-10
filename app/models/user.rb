class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook github google_oauth2]

  has_one :professional_profile
  has_many :projects
  has_many :project_proposals
  has_many :feedbacks_created, class_name: 'Feedback', foreign_key: :feedback_creator_id
  has_many :feedbacks_received, class_name: 'Feedback', foreign_key: :feedback_receiver_id

  enum role: { user: 10, professional: 20, admin: 900 }

  validates :role, presence: true
  validates :role, inclusion: %w[user professional], on: %i[create]
  validates :role, exclusion: %w[admin], on: %i[create]

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
      user.role = :user
    end
  end

  def average_score_received?
    feedbacks_received.average(:score) || 0
  end
end
