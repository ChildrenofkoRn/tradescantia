FactoryBot.define do
  factory :rank do
    association :author, factory: :user
    association :rankable, factory: :review

    score { (1..7).to_a.sample }
  end
end
