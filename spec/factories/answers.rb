FactoryBot.define do
  factory :answer do
    question
    body { "MyText" }

    trait :invalid do
      body { nil }
      question { nil }
    end

  end
end
