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
          visit dashboard_users_path
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
          # expect(page.all('a.link-review').count).to eql(10)
        end
      end
    end
  end
end
