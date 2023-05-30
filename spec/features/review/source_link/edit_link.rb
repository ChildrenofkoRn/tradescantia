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

      scenario 'edit source link' do
        new_title = "Babylon Berlin"
        new_url = "https://www.imdb.com/title/tt4378376/"

        click_on 'Edit'

        within('.source-link') do
          fill_in 'Title Link', with: new_title
          fill_in 'URL', with: new_url
        end

        click_on 'Save'

        expect(page).to have_link new_title, href: new_url

        expect(find_link(new_title)[:target]).to eq('_blank')
      end

      scenario 'tries to edit with errors' do
        click_on 'Edit'

        within('.source-link') do
          fill_in 'URL', with: ''
        end

        click_on 'Save'

        expect(page).to have_content "Link url can't be blank"
      end
    end

  end

end
