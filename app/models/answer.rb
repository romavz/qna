class Answer < ApplicationRecord
  belongs_to :question, foreign_key: :question_id, inverse_of: :answers, required: true
  belongs_to :user, foreign_key: :user_id, inverse_of: :answers, required: true

  validates :body, presence: true
end
