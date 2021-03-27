FactoryBot.define do
  factory :comment do
    body { 'MyCommentText' }
    user

    trait :invalid_comment do
      body { nil }
    end
  end
end
