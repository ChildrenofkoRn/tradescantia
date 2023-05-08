FactoryBot.define do
  factory :review do
    association :author, factory: :user

    sequence(:title) { |n| "title # #{n}" }
    sequence(:body) { |n| "body # #{n}" }

    trait :invalid do
      title { nil }
      body { nil }
    end

    trait :with_link do
      association :link
    end

    trait :with_rank do
      after(:create) do |review|
        create_list :rank, 3, rankable: review
      end
    end
  end
end
