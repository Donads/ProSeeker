require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:project_proposals) }
  end

  describe 'define_enum' do
    it { should define_enum_for(:status).with_values(open: 10, closed: 20, finished: 30) }
    it {
      should define_enum_for(:attendance_type).with_values(mixed_attendance: 10, remote_attendance: 20,
                                                           presential_attendance: 30)
    }
  end

  describe 'presence' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:skills) }
    it { should validate_presence_of(:max_hourly_rate) }
    it { should validate_presence_of(:open_until) }
    it { should validate_presence_of(:attendance_type) }
  end

  describe 'numericality' do
    it { should validate_numericality_of(:max_hourly_rate).is_greater_than(0) }
  end

  describe 'open_until_cannot_be_in_the_past' do
    it { should_not allow_values(Date.yesterday).for(:open_until) }
    it { should allow_values(Date.current).for(:open_until) }
    it { should allow_values(Date.tomorrow).for(:open_until) }
  end

  describe 'open_until_must_be_within_limit' do
    it { should allow_values(1.year.from_now - 1.day).for(:open_until) }
    it { should_not allow_values(1.year.from_now + 1.day).for(:open_until) }
  end
end
