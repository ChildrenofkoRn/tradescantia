require 'rails_helper'

feature 'Author can delete a review', %q{
  As an Author of the review
  I'd like to be able to delete a review
} do
  given(:author) { create(:user) }
  given(:review) { create(:review, author: author) }

  describe 'Authenticated' do

    describe 'as User' do
      background do
        log_in(author)
      end

      describe 'as the author of the review' do

        background do
          visit review_path(review)
        end

        scenario 'delete' do
          click_on 'Delete'

          expect(page).to have_content "The review \"#{review.title}\" was successfully deleted."

          within('.reviews') do
            expect(page).to_not have_content review.title
            expect(page).to_not have_content review.body
          end
        end

      end

      describe 'as non-author of the review' do

        given(:another_users_review) { create(:review) }

        scenario 'is trying to delete' do
          visit review_path(another_users_review)

          expect(page).to_not have_link 'Delete'
        end
      end
    end

    describe 'as Admin' do
      given(:admin) { create(:admin) }

      background do
        log_in(admin)
      end

      scenario 'deleting a user review' do
        visit review_path(review)

        click_on 'Delete'

        expect(page).to have_content "The review \"#{review.title}\" was successfully deleted."

        within('.reviews') do
          expect(page).to_not have_content review.title
          expect(page).to_not have_content review.body
        end
      end
    end

  end

  describe 'Unauthenticated user' do
    scenario 'is trying to delete ' do
      visit review_path(review)

      expect(page).to_not have_link 'Delete'
    end
  end

end
