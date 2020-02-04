FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question title #{n}" }
    sequence(:body) { |n| "My text #{n}" }

    trait :invalid do
      title { nil }
    end

    factory :question_with_answers do
      transient do
        answers_count { 5 }
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end
end
