FactoryBot.define do
  sequence :title do |n|
    "MyQuestionString#{n}"
  end

  factory :question do
    title
    body { "MyQuestionText" }
    user
  end

  trait :invalid_question do
    title { nil }
  end
end
