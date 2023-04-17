require 'rails_helper'

feature 'User can see a new review on page reviews', %q{
  As an user
  I'd like to be able see a new review by other users
  without reload page
} do

  given(:review_attrs) { attributes_for(:review, title: "Muse - The Handler")}
  given!(:reviws) { create_list(:review, 2)}
  given(:author) { create(:user)}

  scenario 'Review appears on another user page', js: true do

    Capybara.using_session('user') do
      log_in(author)
      visit new_review_path
    end

    Capybara.using_session('guest') do
      visit reviews_path
    end

    Capybara.using_session('user') do
      fill_in 'Title', with: review_attrs[:title]
      fill_in 'Body', with: review_attrs[:body]
      click_on 'Create'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content review_attrs[:title]
    end
  end

end
