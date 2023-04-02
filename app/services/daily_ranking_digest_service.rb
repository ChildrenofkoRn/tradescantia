class DailyRankingDigestService
  def send_digest
    reviews_ids = top_reviews_last_day_by_rank.map(&:id)
    return if reviews_ids.empty?

    User.order(created_at: :desc).find_each(batch_size: 100) do |user|
      DailyRankingDigestMailer.ranking_digest(user, reviews_ids).deliver_later
    end
  end

  private

  def top_reviews_last_day_by_rank(top: 5)
    ranks = Rank.arel_table
    rank_avg = Arel::Nodes::NamedFunction.new('COALESCE', [ranks[:score], 0])
    Review.left_joins(:ranks)
          .where(created_at: Date.yesterday.all_day)
          .group(:id)
          .select(:id, :created_at, rank_avg.average.as("rank_avg"))
          .order(rank_avg: :desc, created_at: :desc)
          .limit(top)
  end
end
