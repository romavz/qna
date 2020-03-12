class Answer < ApplicationRecord
  default_scope { order(best: :desc, id: :asc) }

  belongs_to :question, inverse_of: :answers
  belongs_to :user, inverse_of: :answers

  validates :body, presence: true

  def mark_as_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
