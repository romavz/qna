class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers
  belongs_to :user, inverse_of: :answers

  validates :body, presence: true

  def best?
    id == question.best_answer_id
  end
end
