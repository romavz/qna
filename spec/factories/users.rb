FactoryBot.define do
  sequence(:email) { |n| "user#{n}@mail.com" }
  
  factory :user do
    email
    password { "q12345678" }
  end
end
