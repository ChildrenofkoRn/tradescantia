require 'rails_helper'

feature 'User can create review', %q{
  As an authenticated user
  I'd like to be able create a review
  with my title & text
} do

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      log_in(user)

      visit reviews_path
      click_on 'Add review'
    end

    scenario 'add a review' do
      fill_in 'Title', with: 'Review title'
      fill_in 'Body', with: 'Review text'
      click_on 'Create'

      expect(page).to have_content 'Review title'
      expect(page).to have_content 'Review text'
      expect(page).to have_content user.username
    end

    scenario 'add a review with errors' do
      click_on 'Create'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user tries to' do

    scenario 'add a review' do
      visit reviews_path
      click_on 'Add review'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'

      expect(page).to_not have_field("Title")
      expect(page).to_not have_button("Create")
    end
  end

end
