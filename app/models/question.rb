class Question < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, inverse_of: :questions, required: true
  has_many :answers, dependent: :destroy
  validates :title, :body, presence: true
end
