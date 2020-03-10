class Question < ApplicationRecord
  belongs_to :user, inverse_of: :questions
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end
end
