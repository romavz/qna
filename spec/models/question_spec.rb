require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user).required }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:best_answer).class_name('Answer').optional }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { is_expected.to callback(:clear_best_answer_reference).before(:destroy) }

  context 'question has best answer' do
    let(:question) { create :question }
    let(:answer) { create :answer, question: question }

    before { question.update(best_answer_id: answer.id) }

    it 'best_answer_id must be present' do
      expect(question.best_answer_id).to be
    end

    describe '#clear_best_answer_reference' do
      it 'set best_answer_id to nil' do
        question.clear_best_answer_reference
        expect(question.best_answer_id).to be nil
      end
    end
  end
end
