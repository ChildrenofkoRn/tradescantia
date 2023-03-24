FactoryBot.define do
  factory :user do

    sequence(:username) { |n| "#{n}_username" }
    sequence(:email) { |n| "#{n}_user@example.edu" }

    password { '0987654321' }
    password_confirmation { '0987654321' }
    confirmed_at { Time.now }


    trait :unconfirmed do
      confirmed_at { nil }
    end

    factory :admin do
      type { 'Admin' }
    end

  end
end
