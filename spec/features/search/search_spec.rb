require 'rails_helper'

feature 'user can search on the site', %q{
  As an user
  I'd like to be able to search on site materials
  I'd like to be able on select resource to search
} do

  given!(:user) { create(:user, username: 'Reality') }
  given!(:review) { create(:review, author: user, title: 'My Nightmares Turned into Reality') }
  given!(:reviews) { create_list(:review, 2) }
  given(:not_found_mess) { "Oops! Try another search phrase, minimum 3 characters" }

  background do
    visit root_path
  end

  # TODO check for each type of user Visitor/User/Admin

  scenario 'by everywhere' do
    search(user.username)

    within('.results') do
      expect(page).to have_content(user.username, count: 2)

      reviews.each do |review|
        expect(page).to_not have_content(review.title)
      end
    end
  end

  scenario 'by reviews' do
    search(user.username, by: "review")

    within('.results') do
      expect(page).to have_content("My Nightmares Turned into", count: 1)
    end
  end

  scenario 'by user' do
    search(user.username, by: "user")

    within('.results') do
      expect(page).to have_content(user.username, count: 1)
      expect(page).to_not have_content("My Nightmares Turned into")
    end
  end

  # TODO repeat for users

  describe 'updated review is reflected in the search results' do

    background do
      log_in(user)
    end

    scenario 'a new review appears' do
      title = "Falling in Reverse - Coming Home"
      search(title)
      expect(page).to have_content(not_found_mess)

      visit root_path
      click_on 'Add review'
      fill_in 'Title', with: title
      fill_in 'Body', with: 'song'
      click_on 'Create'

      search(title)
      within('.results') do
        expect(page).to have_content(title, count: 1)
      end
    end

    scenario 'deleted review drops out' do
      search(review.title)

      within('.results') do
        expect(page).to have_content(review.title, count: 1)
      end

      visit review_path(review)
      click_on 'Delete'

      search(review.title)
      expect(page).to have_content(not_found_mess)
    end

    scenario 'edited review available' do
      search(review.title)

      within('.results') do
        expect(page).to have_content(review.title, count: 1)
      end

      new_title = "Born with Nothing, Die with Everything"
      visit review_path(review)
      click_on 'Edit'
      fill_in 'Title', with: new_title
      click_on 'Save'

      search(review.title)
      expect(page).to have_content(not_found_mess)

      search(new_title)
      within('.results') do
        expect(page).to have_content(new_title, count: 1)
      end
    end

  end

  private

  def search(query, by: 'site')
    within('.search') do
      fill_in :search_query, with: query
      select by, from: :search_type
      click_on 'go'
    end
  end
end
