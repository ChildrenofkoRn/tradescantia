require 'rails_helper'

feature 'User can provide a link to the source', %q{
  As an authenticated user
  I'd like to be able to provide a link to the source
  with my title
} do

  describe 'Authenticated' do

    describe 'as User' do
      given(:user) { create(:user) }

      background do
        log_in(user)

        visit reviews_path
        click_on 'Add review'
      end

      scenario 'add a source link' do
        fill_in 'Title', with: 'Review title'
        fill_in 'Body', with: 'Review text'

        fill_in 'Source link title', with: 'Groundhog Day (1993)'
        fill_in 'Source link', with: 'https://www.imdb.com/title/tt0107048/'

        click_on 'Create'

        expect(page).to have_link 'Groundhog Day (1993)', href: 'https://www.imdb.com/title/tt0107048/'
      end
    end
  end

end
