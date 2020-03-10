require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).required }
  it { should belong_to(:user).required }
  it { should have_db_column :user_id }
  it { should have_db_column(:best) }

  it { should have_db_index :question_id }
  it { should validate_presence_of :body }

  describe 'Ordering. By default' do
    let!(:question) { create :question }
    let!(:answers) { [] }

    before do
      answers << create(:answer, question: question)
      answers << create(:answer, question: question)
      answers << create(:answer, question: question)

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

    before(:each) do
      expect(answer_1.best).to be true
      expect(answer_2.best).to be false
    end

    it 'change answer "best" state to true' do
      expect { answer_2.mark_as_best }.to change(answer_2, :best).to(true)
    end

    it 'best answers count will be one' do
      answer_2.mark_as_best
      expect(question.answers.where(best: true).count).to eq 1
    end
  end
end
