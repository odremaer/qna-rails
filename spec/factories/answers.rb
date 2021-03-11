FactoryBot.define do
  factory :answer do
    body { "MyAnswerText" }
    question
    user
  end

  trait :invalid_answer do
    body { nil }
  end
end
