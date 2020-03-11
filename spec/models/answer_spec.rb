require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).required }
  it { should belong_to(:user).required }
  it { should have_db_column :user_id }
  it { should have_db_column(:best) }

  it { should have_db_index :question_id }
  it { should validate_presence_of :body }

  describe 'Ordering. By default' do
    let!(:question) { create :question, :with_answers, answers_count: 3 }
    let!(:answers) { question.answers.to_a }

    before do
      answers.third.update(best: true)
    end

    it 'answers must be ordered by: [best: desc, id: asc]' do
      expect(question.answers.all).to match_array [answers.third, answers.first, answers.second]
    end
  end

  describe '#mark_as_best' do
    let!(:question) { create :question }
    let!(:answer_1) { create :answer, question: question, best: true }
    let!(:answer_2) { create :answer, question: question }

    it 'change answer "best" state to true' do
      expect { answer_2.mark_as_best }.to change(answer_2, :best).to(true)
    end

    it 'best answers count will be one' do
      answer_2.mark_as_best
      expect(question.answers.where(best: true).count).to eq 1
    end

    RSpec::Matchers.define_negated_matcher :not_change, :change

    context 'when error rised' do
      it 'do not make changes in any answer' do
        expect(answer_2).to receive(:update!).and_raise("error")
        expect { answer_2.mark_as_best }
          .to raise_error("error")
          .and(not_change { answer_1.attributes })
          .and(not_change { answer_2.attributes })
      end
    end
  end
end
