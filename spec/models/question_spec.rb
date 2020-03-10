require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user).required }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#best_answer' do
    let!(:question) { create :question, :with_answers }

    context 'when no one answer marked as best' do
      subject { question.best_answer }

      it { should be_nil }
    end

    context 'when one answer marked as best' do
      let!(:best_answer) { create :answer, question: question, best: true }

      it 'should return that answer' do
        expect(question.best_answer).to eq best_answer
      end
    end
  end
end
