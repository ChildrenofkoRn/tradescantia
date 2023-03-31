class DailyRankingDigestMailer < ApplicationMailer

  def ranking_digest(user)
    @user = user
    @reviews = Review.by_date.where(created_at: Date.yesterday.all_day)

    mail to: user.email
  end
end
