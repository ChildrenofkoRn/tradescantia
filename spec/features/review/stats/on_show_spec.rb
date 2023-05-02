require 'rails_helper'

feature 'User can see views stats', %q(
  I would like to see the number of views on the review,
  even if i am not registered
) do

  given!(:review) { create(:review) }

  describe 'as Unauthenticated user' do
    background do
      visit review_path(review)
    end

    scenario 'a review' do
      expect(page).to have_content("Views: 1")
    end

  end

  describe 'as Authenticated user' do
    background do
      log_in(create(:user))
      visit review_path(review)
    end

    scenario 'a review' do
      expect(page).to have_content("Views: 1")
    end
  end
end
