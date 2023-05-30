FactoryBot.define do
  factory :link do
    association :review

    title { "eXistenZ (1999)" }
    url { "https://www.imdb.com/title/tt0120907/" }

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
