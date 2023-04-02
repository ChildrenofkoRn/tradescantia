# Preview all emails at http://localhost:3000/rails/mailers/daily_ranking_digest
class DailyRankingDigestPreview < ActionMailer::Preview

  def digest
    DailyRankingDigestMailer.ranking_digest(User.all.sample)
  end

end
