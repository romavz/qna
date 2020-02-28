class Question < ApplicationRecord
  belongs_to :user, inverse_of: :questions
  has_many :answers, dependent: :destroy
  has_one :best_answer, class_name: 'Answer'
  validates :title, :body, presence: true
end
