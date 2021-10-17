require 'rails_helper'

RSpec.describe KnowledgeField, type: :model do
  context 'validates presence' do
    it 'title must be present' do
      knowledge_field = KnowledgeField.new
      knowledge_field.valid?
      expect(knowledge_field.errors.full_messages_for(:title)).to include('Título não pode ficar em branco')
    end
  end

  context 'validates presence' do
    it 'title must be present' do
      KnowledgeField.create(title: 'Teste de duplicidade')
      knowledge_field = KnowledgeField.new(title: 'Teste de duplicidade')
      knowledge_field.valid?
      expect(knowledge_field.errors.full_messages_for(:title)).to include('Título já está em uso')
    end
  end
end
