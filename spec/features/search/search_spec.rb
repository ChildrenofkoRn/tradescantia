require 'sphinx_helper'

feature 'user can search on the site', %q{
  As an user
  I'd like to be able to search on site materials
  I'd like to be able on select resource to search
}, sphinx: true, js: true do

  given!(:user) { create(:user) }
  given!(:review) { create(:review, author: user, title: 'My Nightmares Turned into Reality') }
  given!(:reviews) { create_list(:review, 2) }

  background do
    visit root_path
  end

  scenario 'by everywhere' do
    ThinkingSphinx::Test.run do
      search(review.title)

      expect(page).to have_content review.title

      reviews.each do |review|
        expect(page).to_not have_content review.title
      end
    end
  end

  private

  def search(query, by: 'site')
    within('.search') do
      fill_in :search_query, with: query
    end

    select by, from: :search_type
    click_on 'go'
  end
end
