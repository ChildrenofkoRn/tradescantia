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

      scenario 'to give a ranking' do
        visit review_path(review)

        expect(page).to have_link 'ranking'
      end

    end

    describe 'as a review author' do

      given(:own_review) { create(:review, author: user) }

      scenario 'tries to give a ranking' do
        visit review_path(own_review)

        expect(page).to_not have_link 'ranking'
      end
    end

  end

  describe 'Unauthenticated user' do

    given(:review) { create(:review) }

    scenario 'tries to give a ranking' do
      visit review_path(review)

      expect(page).to_not have_link 'ranking'
    end
  end

end
