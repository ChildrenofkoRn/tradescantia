FactoryBot.define do
  factory :review do
    association :author, factory: :user

    sequence(:title) { |n| "title # #{n}" }
    sequence(:body) { |n| "body # #{n}" }

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
