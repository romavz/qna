class Answer < ApplicationRecord
  belongs_to :question, foreign_key: :question_id, dependent: :destroy, required: true

  validates :body, presence: true
end
