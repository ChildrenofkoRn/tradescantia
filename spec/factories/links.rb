FactoryBot.define do
  factory :link do
    association :review

    title { "eXistenZ (1999)" }
    url { "https://www.imdb.com/title/tt0120907/" }
  end
end
