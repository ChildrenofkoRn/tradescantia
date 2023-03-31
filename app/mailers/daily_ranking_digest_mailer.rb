class DailyRankingDigestMailer < ApplicationMailer

  def ranking_digest(user, reviews_ids)
    @user = user
    @reviews = Review.where(id: reviews_ids)

    mail to: user.email
  end
end
