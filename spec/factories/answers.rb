FactoryBot.define do
  factory :answer do
    user
    question
    body { "My answer Text" }

    trait :invalid do
      body { nil }
      question { nil }
    end

  end
end
