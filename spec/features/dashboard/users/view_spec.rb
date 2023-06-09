require 'rails_helper'

feature 'Admin can see a list of users or a review', %q(
  Users and Unauthenticated do not have access to
) do

  given!(:users) { create_list(:user, 4) }

  describe 'Authenticated' do

    describe 'as Admin' do
      background do
        log_in(create(:admin))
      end


      describe 'sees' do
        background do
          click_on 'Dashboard'
        end

        scenario 'a list of users' do
          users.each { |user| expect(page).to have_content(user.username) }
        end
      end

      describe 'pagination' do
        given!(:users) { create_list(:user, 25) }

        background do
          visit dashboard_users_path
        end

        scenario 'sees two paginations' do
          expect(page.all("nav.page.pagination").count).to eql(2)
        end

        scenario '15 users per page' do
          expect(page.all('tr.user').count).to eql(15)
        end

        scenario 'goes to the second page'  do
          within(all("nav.page.pagination").first) do
            click_link('2', href: /\?page=2*/)
          end

          expect(page.all("nav.page.pagination").count).to eql(2)
        end
      end
    end

    describe 'as User' do
      background do
        log_in(users.first)
        visit dashboard_users_path
      end

      scenario 'tries open dashboard via menu' do
        visit root_path
        expect(page).to_not have_link('', href: '/dashboard/users')
      end

      scenario 'tries to visit' do
        expect(page).to have_current_path(root_path)
        expect(page).to have_content("You are not authorized to perform this action.")
      end
    end
  end

  describe 'Unauthenticated user' do

    scenario 'tries open dashboard via menu' do
      visit root_path
      expect(page).to_not have_link('', href: '/dashboard/users')
    end

    scenario 'tries to visit' do
      visit dashboard_users_path
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end
end
