FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question
  end

  trait :invalid_answer do
    body { nil }
  end
end
