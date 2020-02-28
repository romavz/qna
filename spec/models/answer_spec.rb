require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).required }
  it { should belong_to(:user).required }
  it { should have_db_index :question_id }
  it { should validate_presence_of :body }

  describe '#best?' do
    let(:question) { create :question }
    let(:answer) { create :answer, question: question }

    context 'for best answer' do
      before { question.update(best_answer_id: answer.id) }
      it 'should return true' do
        expect(answer).to be_best
      end
    end

    context 'for other answer' do
      it 'should return false' do
        expect(answer).not_to be_best
      end
    end
  end
end
