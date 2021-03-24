FactoryBot.define do
  factory :vote do
    value {0}
    user
  end

  trait :answer do
    association :votable, factory: :answer
  end

  trait :question do
    association :votable, factory: :question
  end
end
