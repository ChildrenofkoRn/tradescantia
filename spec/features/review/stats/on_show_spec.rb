require 'rails_helper'

feature 'User can see views stats', %q(
  I would like to see the number of views on the review,
  even if i am not registered
) do

  given!(:review) { create(:review) }
  given!(:selector) { '.views > td' }

  describe 'as Unauthenticated user' do
    background do
      visit review_path(review)
    end

    scenario 'a review' do
      expect(find(selector)).to have_content("0")

      refresh
      expect(find(selector)).to have_content("1")
    end

  end

  describe 'as Authenticated user' do
    background do
      log_in(create(:user))
      visit review_path(review)
    end

    scenario 'a review' do
      expect(find(selector)).to have_content("0")

      refresh
      expect(find(selector)).to have_content("1")
    end
  end
end
