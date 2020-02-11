class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', inverse_of: :questions, required: true
  has_many :answers, dependent: :destroy
  validates :title, :body, presence: true
end
