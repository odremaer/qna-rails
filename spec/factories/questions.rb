FactoryBot.define do
  factory :question do
    title { "MyQuestionString" }
    body { "MyQuestionText" }
    user
  end

  trait :invalid_question do
    title { nil }
  end
end
