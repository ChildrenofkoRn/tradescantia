require 'rails_helper'

feature 'User can sort reviews on page', %q(
  I would like to sort reviews on page by Title and Rank,
  even if i am not registered
), js: true do

  given!(:reviews) { create_list(:review, 2, :with_rank) }

  background do
    # FIX if avg_rank eq between reviews then test "sort by rank" fall
    if reviews.first.stat.rank_avg == reviews.last.stat.rank_avg
      rank = reviews.first.ranks.first
      rank.score = ([*1..7] - [6]).sample
      rank.save
    end
  end

  describe 'as Unauthenticated user' do
    background do
      visit reviews_path
    end

    scenario 'sort by title' do
      expect(reviews.last.title).to appear_before(reviews.first.title)
      find('.sort-by-title').click

      expect(reviews.first.title).to appear_before(reviews.last.title)
    end

    scenario 'sort by rank' do
      sorted_by_time = reviews.sort_by { |review| review.created_at }.reverse!
      expect(sorted_by_time.first.title).to appear_before(sorted_by_time.last.title)

      find('.sort-by-rank').click

      sorted_by_rank = reviews.sort_by { |review| review.stat.rank_avg }
      expect(sorted_by_rank.first.title).to appear_before(sorted_by_rank.last.title)
    end
  end

  describe 'as Authenticated user' do
    background do
      log_in(create(:user))
      visit reviews_path
    end

    scenario 'sort by title' do
      expect(reviews.last.title).to appear_before(reviews.first.title)
      find('.sort-by-title').click

      expect(reviews.first.title).to appear_before(reviews.last.title)
    end

    scenario 'sort by rank' do
      sorted_by_time = reviews.sort_by { |review| review.created_at }.reverse!
      expect(sorted_by_time.first.title).to appear_before(sorted_by_time.last.title)

      find('.sort-by-rank').click

      sorted_by_rank = reviews.sort_by { |review| review.stat.rank_avg }
      expect(sorted_by_rank.first.title).to appear_before(sorted_by_rank.last.title)
    end
  end

end
