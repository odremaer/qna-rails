FactoryBot.define do
  sequence :body do |n|
    "MyAnswerText#{n}"
  end

  factory :answer do
    body
    question
    user
  end

  trait :invalid_answer do
    body { nil }
  end
end
