require 'rails_helper'

feature 'Author can edit a review', %q{
  As an Author of the review
  I'd like to be able edit a review
} do
  given(:author) { create(:user) }
  given(:review) { create(:review, author: author) }

  describe 'Authenticated user' do
    background do
      log_in(author)
    end

    describe 'as the author of the review' do

      background do
        visit review_path(review)
      end

      given(:review_edited) { build(:review) }

      scenario 'edits' do
        click_on 'Edit'
        fill_in 'Title', with: review_edited.title
        fill_in 'Body', with: review_edited.body
        click_on 'Save'

        expect(page).to_not have_content review.title
        expect(page).to_not have_content review.body

        expect(page).to have_content review_edited.title
        expect(page).to have_content review_edited.body
        expect(page).to have_content author.username
      end

      scenario 'tries to edit with errors' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end

    end

    describe 'as non-author of the review' do

      given(:another_users_review) { create(:review) }

      scenario 'is trying to edit ' do
        visit review_path(another_users_review)

        expect(page).to_not have_link 'Edit'
      end
    end

  end

  describe 'Unauthenticated user' do
    scenario 'is trying to edit ' do
      visit review_path(review)

      expect(page).to_not have_link 'Edit'
    end
  end
end