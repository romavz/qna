class Answer < ApplicationRecord
  belongs_to :question, foreign_key: :question_id, required: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', inverse_of: :answers, required: true

  validates :body, presence: true
end
