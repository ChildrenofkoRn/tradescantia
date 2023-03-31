class DailyRankingDigestService
  def send_digest
    reviews_ids = Review.by_date.where(created_at: Date.yesterday.all_day).limit(5).pluck(:id)
    return if reviews_ids.empty?

    User.order(created_at: :desc).find_each(batch_size: 100) do |user|
      DailyRankingDigestMailer.ranking_digest(user, reviews_ids).deliver_later
    end
  end
end
