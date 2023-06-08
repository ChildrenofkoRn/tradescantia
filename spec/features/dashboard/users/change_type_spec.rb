require 'rails_helper'

feature 'Admin can see a list of users or a review', %q(
  Users and Unauthenticated dont have access
) do

  given!(:users) { create_list(:user, 2) }
  given!(:admins) { create_list(:user, 2, type: "Admin") }
  given!(:admin) { create(:admin) }

  describe 'Authenticated' do

    describe 'as Admin' do
      background do
        log_in(admin)
        click_on 'Dashboard'
      end

      scenario 'change type User to Admin', js: true do
        user_by_id = proc { |user| "[data-user-id='#{user.id}']" }
        user_type  = proc { |user| "#{user_by_id.call(user)} > .type" }

        within('.users') do
          users.each do |user|
            type = find(user_type.call(user))
            expect(type).to have_content("User", exact: true)

            user_row = find(user_by_id.call(user))
            user_row.check("user-flag")
          end

          accept_confirm do
            click_on 'Make Admin'
          end

          users.each do |user|
            type = find(user_type.call(user))
            expect(type).to have_content("Admin", exact: true)
          end

          # Additional verification that the data have really changed
          page.refresh
          users.each do |user|
            type = find(user_type.call(user))

            expect(type).to have_content("Admin", exact: true)
          end
        end
      end

      scenario 'change type Admin to User', js: true do

        user_by_id = proc { |user| "[data-user-id='#{user.id}']" }
        user_type  = proc { |user| "#{user_by_id.call(user)} > .type" }

        within('.users') do
          admins.each do |user|
            type = find(user_type.call(user))
            expect(type).to have_content("Admin", exact: true)

            user_row = find(user_by_id.call(user))
            user_row.check("user-flag")
          end

          accept_confirm do
            click_on 'Make User'
          end

          admins.each do |user|
            type = find(user_type.call(user))
            expect(type).to have_content("User", exact: true)
          end

          # Additional verification that the data have really changed
          page.refresh
          admins.each do |user|
            type = find(user_type.call(user))

            expect(type).to have_content("User", exact: true)
          end
        end
      end

    end

  end
end
