require 'rails_helper'

RSpec.describe DailyRankingDigestService do

  it 'sends daily digest to all users ' do
    users = create_list(:user, 5)

    # create reviews
    review = create(:review, created_at: Date.yesterday, author: users.first)

    users.each { |user| expect(DailyRankingDigestMailer).to receive(:ranking_digest)
                                                        .with(user, [review.id])
                                                        .and_call_original }

    subject.send_digest
  end

  it 'sends top5 daily digest with order rank_avg & review.created_at' do
    users = create_list(:user, 2)

    # create reviews
    # outdated w rank
    outdated = create(:review, created_at: Date.today.days_ago(3), author: users.first)
    create(:rank, rankable: outdated, author: users.last)
    # yesterday with different times for the sorting test
    reviews_last_day = create_list(:review, 12, author: users.first) do |review, i|
      review.update_attribute(:created_at, Date.yesterday + i.minutes)
    end

    # select every second yesterday reviews & ranking
    reviews_ranked = reviews_last_day.each_slice(2).map(&:last)
    reviews_ranked.map { |review| create(:rank, rankable: review, author: users.last) }

    # sort by rank avg score & review.created_at
    reviews_sorted = reviews_ranked.sort_by { |review| [review.rank, review.created_at.to_i] }.reverse!

    # get first top 5
    reviews_sort_by_rank_ids = reviews_sorted.first(5).map(&:id)

    users.each { |user| expect(DailyRankingDigestMailer).to receive(:ranking_digest)
                                                              .with(user, reviews_sort_by_rank_ids)
                                                              .and_call_original }

    subject.send_digest
  end

end
