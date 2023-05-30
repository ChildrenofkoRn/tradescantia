FactoryBot.define do
  factory :stat do
    association :statable, factory: :review

    views { 0 }
    ranks_count { 0 }
    rank_avg { 0 }
  end
end
