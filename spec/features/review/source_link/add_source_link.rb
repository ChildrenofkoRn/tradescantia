require 'rails_helper'

feature 'User can provide a link to the source', %q{
  As an authenticated user
  I'd like to be able to provide a link to the source
  with my title
} do

  describe 'Authenticated' do

    describe 'as User' do
      given(:user) { create(:user) }
      given(:src_link_title) { 'Groundhog Day (1993)' }
      given(:src_link_url) { 'https://www.imdb.com/title/tt0107048/' }

      background do
        log_in(user)

        visit reviews_path
        click_on 'Add review'
      end

      scenario 'add a source link' do
        fill_in 'Title', with: 'Review title'
        fill_in 'Body', with: 'Review text'

        within('.source-link') do
          fill_in 'Title Link', with: src_link_title
          fill_in 'URL', with: src_link_url
        end

        click_on 'Create'

        expect(page).to have_link src_link_title, href: src_link_url
        expect(find_link(src_link_title)[:target]).to eq('_blank')
      end
    end

  end

end
