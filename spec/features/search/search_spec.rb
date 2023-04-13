require 'rails_helper'

feature 'user can search on the site', %q{
  As an user
  I'd like to be able to search on site materials
  I'd like to be able on select resource to search
} do

  given!(:user) { create(:user, username: 'Reality') }
  given!(:review) { create(:review, author: user, title: 'My Nightmares Turned into Reality') }
  given!(:reviews) { create_list(:review, 2) }

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

  scenario 'a new review appears in the search' do
    title = "Falling in Reverse - Coming Home"
    search(title)
    expect(page).to have_content("Oops! Try another search phrase, minimum 3 characters")

    create(:review, author: user, title: title)
    search(title)
    within('.results') do
      expect(page).to have_content(title, count: 1)
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