require 'rails_helper'

feature 'User can give a ranking after reading a review', %q(
  I'd like to be able to rank a review,
  Authors should not vote for their reviews,
  Unauthenticated users should not vote for reviews
) do

  describe 'Authenticated user' do

    given(:user) { create(:user) }

    background do
      log_in(user)
    end

    describe 'as a review non-author' do

      given(:review) { create(:review) }
      background do
        visit review_path(review)
      end

      (Rank::RANGE).to_a.each do |score|
        scenario "to give a ranking #{score}", js: true do
          click_link(href: "/reviews/#{review.id}/ranking?rank=#{score}")
          sleep 0.5
          expect(page).to_not have_link(href: /\/reviews\/#{review.id}\/ranking\?rank=/)
          page.find(".rank").has_css?(".bi-star-fill")
          expect(page).to have_content("Total: avarage: #{score.to_f} (1 times)")
        end
      end

    end

    describe 'as a review author' do

      given(:own_review) { create(:review, author: user) }

      scenario 'tries to give a ranking' do
        visit review_path(own_review)

        expect(page).to_not have_link(href: /\/reviews\/#{own_review.id}\/ranking\?rank=/)
      end
    end

  end

  describe 'Unauthenticated user' do

    given(:review) { create(:review) }

    scenario 'tries to give a ranking' do
      visit review_path(review)

      expect(page).to_not have_link(href: /\/reviews\/#{review.id}\/ranking\?rank=/)
    end
  end

end
