class Question < ApplicationRecord
  belongs_to :user, inverse_of: :questions
  has_many :answers, dependent: :destroy
  validates :title, :body, presence: true
end
