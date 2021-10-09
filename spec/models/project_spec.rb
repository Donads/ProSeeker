require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'validates presence' do
    it 'title must be present' do
      project = Project.new
      project.valid?
      expect(project.errors.full_messages_for(:title)).to include('Título não pode ficar em branco')
    end

    it 'description must be present' do
      project = Project.new
      project.valid?
      expect(project.errors.full_messages_for(:description)).to include('Descrição não pode ficar em branco')
    end

    it 'skills must be present' do
      project = Project.new
      project.valid?
      expect(project.errors.full_messages_for(:skills)).to include('Habilidades desejadas não pode ficar em branco')
    end

    it 'max_hourly_rate must be present' do
      project = Project.new
      project.valid?
      expect(project.errors.full_messages_for(:max_hourly_rate)).to include('Valor máximo (R$/hora) não pode ficar em branco')
    end

    it 'open_until must be present' do
      project = Project.new
      project.valid?
      expect(project.errors.full_messages_for(:open_until)).to include('Prazo para recebimento de propostas não pode ficar em branco')
    end

    it 'attendance_type must be present' do
      project = Project.new
      project.valid?
      expect(project.errors.full_messages_for(:attendance_type)).to include('Tipo de atuação não pode ficar em branco')
    end
  end

  context 'validates numericality' do
    it 'max_hourly_rate must be greater than 0' do
      project = Project.new(max_hourly_rate: -0.1)
      project.valid?
      expect(project.errors.full_messages_for(:max_hourly_rate)).to include('Valor máximo (R$/hora) deve ser maior que 0')
    end

    it 'max_hourly_rate must be greater than 0' do
      project = Project.new(max_hourly_rate: 0)
      project.valid?
      expect(project.errors.full_messages_for(:max_hourly_rate)).to include('Valor máximo (R$/hora) deve ser maior que 0')
    end

    it 'max_hourly_rate must be greater than 0' do
      project = Project.new(max_hourly_rate: 0.1)
      project.valid?
      expect(project.errors.full_messages_for(:max_hourly_rate)).to eq []
    end
  end

  context 'validates attendance_type' do
    it 'mixed_attendance is valid' do
      project = Project.new(attendance_type: :mixed_attendance)
      project.valid?
      expect(project.errors.full_messages_for(:attendance_type)).to eq []
    end

    it 'remote_attendance is valid' do
      project = Project.new(attendance_type: :remote_attendance)
      project.valid?
      expect(project.errors.full_messages_for(:attendance_type)).to eq []
    end

    it 'presential_attendance is valid' do
      project = Project.new(attendance_type: :presential_attendance)
      project.valid?
      expect(project.errors.full_messages_for(:attendance_type)).to eq []
    end

    it 'other are not valid' do
      # TODO: Implement validation that doesn't raise ArgumentError
    end
  end
end
