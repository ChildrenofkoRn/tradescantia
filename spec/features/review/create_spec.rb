require 'rails_helper'

feature 'User can create review', %q{
  with own title & text
} do

  describe 'Unauthenticated user' do
    background do
      visit reviews_path
      click_on 'Add review'
    end

    scenario 'add a review' do
      fill_in 'Title', with: 'Review title'
      fill_in 'Body', with: 'Review text'
      click_on 'Create'

      expect(page).to have_content 'Review title'
      expect(page).to have_content 'Review text'
    end

    scenario 'add a review with errors' do
      click_on 'Create'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

end
