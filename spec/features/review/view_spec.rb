require 'rails_helper'

feature 'User can see a list of reviews or a review', %q(
  I would like to see a list of reviews and be able to view an individual review,
  even if i am not registered
) do

  given!(:reviews) { create_list(:review, 4) }

  describe 'Unauthenticated user' do

    background do
      visit reviews_path
    end

    scenario 'sees a list of reviews' do
      reviews.each { |review| expect(page).to have_content(review.title) }
    end

    scenario 'sees a review' do
      review = reviews.first
      click_on review.title

      expect(page).to have_content(review.title)
      expect(page).to have_content(review.body)
      expect(page).to have_content(review.author.username)
    end
  end

  describe 'Authenticated user' do

    background do
      log_in(create(:user))
      visit reviews_path
    end

    scenario 'sees a list of reviews' do
      reviews.each { |review| expect(page).to have_content(review.title) }
    end

    scenario 'sees a review' do
      review = reviews.first
      click_on review.title

      expect(page).to have_content(review.title)
      expect(page).to have_content(review.body)
    end
  end
end
