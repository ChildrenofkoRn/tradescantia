require 'rails_helper'

feature 'Author can edit a link to the source', %q{
  As an authenticated user
  I'd like to be able to edit a link to the source
} do

  describe 'Authenticated' do

    describe 'as Author' do
      given(:author) { create(:user) }
      given(:review) { create(:review, :with_link, author: author) }

      background do
        log_in(author)

        visit review_path(review)
      end

      scenario 'delete source link' do
        click_on 'Edit'

        within('.source-link') do
          check('Delete link', allow_label_click: true)
        end

        click_on 'Save'

        expect(page).to_not have_link review.link.url
      end
    end

  end

end
