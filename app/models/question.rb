class Question < ApplicationRecord

  before_destroy :clear_best_answer_reference

  belongs_to :user, inverse_of: :questions
  has_many :answers, dependent: :destroy
  has_one :best_answer, class_name: 'Answer'
  validates :title, :body, presence: true

  def clear_best_answer_reference
    update(best_answer_id: nil)
  end
end
