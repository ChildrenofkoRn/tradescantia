FactoryBot.define do
  factory :stat do
    association :review

    views { 1 }
    ranks_count { 1 }
    rank_avg { 1.5 }
  end
end
