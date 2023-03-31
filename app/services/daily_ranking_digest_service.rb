class DailyRankingDigestService
  def send_digest
    return if Review.by_date.where(created_at: Date.yesterday.all_day).empty?

    User.find_each(batch_size: 100) do |user|
      DailyRankingDigestMailer.ranking_digest(user).deliver_later
    end
  end
end
