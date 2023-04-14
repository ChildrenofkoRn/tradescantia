module Rankable
  extend ActiveSupport::Concern

  included do
    has_many :ranks, as: :rankable, dependent: :destroy

    def rank
      rank = respond_to?(:rank_avg) ? rank_avg : ranks.average(:score).to_f
      rank || 0
    end

    def ranks_count
      respond_to?(:ranks_size) ? ranks_size : ranks.count
    end

    # TODO create model Stat
    def self.with_stats
      ranks = Rank.arel_table
      rank_avg = Arel::Nodes::NamedFunction.new('COALESCE', [ranks[:score], 0])
      left_joins(:ranks)
        .select(
          arel_table[Arel.star],
          ranks[:id].count.as("ranks_size"),
          rank_avg.average.as("rank_avg")
        )
        .group(:id)
    end
  end
end
