require 'rails_helper'

feature 'User can create review', %q{
  with own text
} do

  describe 'Unauthenticated user' do
    background do
      visit reviews_path
      click_on 'Add review'
    end

    scenario 'add a review', js: true do
      fill_in 'Title', with: 'Review title'
      fill_in 'Body', with: 'Review text'
      click_on 'Create review'

      expect(page).to have_content 'Review title'
      expect(page).to have_content 'Review text'
    end
  end

end
