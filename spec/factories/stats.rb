FactoryBot.define do
  factory :stat do
    views { 1 }
    ranks_count { 1 }
    rank_avg { 1.5 }
    review { nil }
  end
end
