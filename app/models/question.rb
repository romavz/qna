class Question < ApplicationRecord
  belongs_to :user, inverse_of: :questions
  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true

end
