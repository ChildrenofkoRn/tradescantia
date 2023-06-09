FactoryBot.define do
  factory :link do
    association :review

    sequence(:title) { |n| "eXistenZ (1999) #{n}" }
    sequence(:url)   { |n| "https://www.imdb.com/title/tt0120907/?none=#{n}" }

    trait :invalid do
      title { 'yep' }
      url { nil }
    end

    trait :empty do
      title { nil }
      url { nil }
    end
  end
end
