FactoryBot.define do
  factory :review do
    sequence(:title) { |n| "title # #{n}" }
    sequence(:body) { |n| "body # #{n}" }
  end
end
