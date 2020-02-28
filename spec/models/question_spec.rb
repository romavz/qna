require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user).required }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:best_answer).class_name('Answer').optional }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
