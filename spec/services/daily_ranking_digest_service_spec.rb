require 'rails_helper'

RSpec.describe DailyRankingDigestService do
  let(:users) { create_list(:user, 4) }

  it 'sends daily ranking digest to all users' do
    reviews_last_day = create_list(:review, 10, created_at: Date.yesterday, author: users.first)
    review_outdated = create(:review, created_at: Date.today.days_ago(3), author: users.first)
    reviews_ids = reviews_last_day.first(5).map(&:id)

    users.each { |user| expect(DailyRankingDigestMailer).to receive(:ranking_digest)
                                                        .with(user, reviews_ids)
                                                        .and_call_original }

    subject.send_digest
  end

end
