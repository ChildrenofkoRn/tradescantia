module Rankable
  extend ActiveSupport::Concern

  included do
    has_many :ranks, as: :rankable, dependent: :destroy

    def rank
      if respond_to?(:rank_avg)
        rank_avg || 0
      else
        ranks.average(:score).to_f || 0
      end
    end

    def ranks_count
      respond_to?(:ranks_size) ? ranks_size : ranks.count
    end


    def self.with_stats
      ranks = Rank.arel_table
      users = User.arel_table
      left_joins(:ranks, :author)
        .group(:id, 'users.username')
        .select(
          arel_table[Arel.star],
          ranks[:id].count.as("ranks_size"),
          ranks[:score].average.as("rank_avg"),
          users[:username].as("username")
        )
    end
  end
end
