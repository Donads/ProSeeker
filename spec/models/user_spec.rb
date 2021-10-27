require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one(:professional_profile) }
    it { should have_many(:projects) }
    it { should have_many(:project_proposals) }
    it { should have_many(:feedbacks_created).class_name('Feedback').with_foreign_key(:feedback_creator_id) }
    it { should have_many(:feedbacks_received).class_name('Feedback').with_foreign_key(:feedback_receiver_id) }
  end

  describe 'define_enum' do
    it { should define_enum_for(:role).with_values(user: 10, professional: 20, admin: 900) }
  end

  describe 'presence' do
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:email) }
  end

  describe 'allow_values' do
    it { should allow_values(:user, :professional).for(:role) }
  end

  describe 'admin restriction' do
    it { should allow_values(:admin).for(:role).on(:update) }
    it { should_not allow_values(:admin).for(:role).on(:create) }
  end
end
