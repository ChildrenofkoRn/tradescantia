require 'rails_helper'

RSpec.describe Dashboard::UsersController, type: :controller do

  describe "GET #change_type" do

    describe "Authenticated user" do

      context 'by Admin' do
        let(:admin_unchanged) { create(:admin) }
        before { login(admin_unchanged) }

        let!(:users) { (create_list(:user, 2)) }
        let!(:user_unchanged) { (create(:user)) }

        context 'with valid attributes' do
          context 'change type to Admin' do
            let(:make_admin) { patch :change_type, params: { user: { ids: users.map(&:id), type: "Admin" } } }

            it "update list users" do
              make_admin
              users.each do |user|
                expect { user.reload }.to change(user, :type).from("User").to("Admin")
              end
            end

            it 'other users are unchanged' do
              make_admin
              expect { user_unchanged.reload }.to_not change(user_unchanged, :type)
            end

            it 'returns 200 status' do
              make_admin
              expect(response).to be_successful
            end
          end


          context 'change type to User' do
            let!(:admins) { (create_list(:user, 2, type: "Admin")) }
            let(:make_user) { patch :change_type, params: { user: { ids: admins.map(&:id), type: "User" } } }

            it "update list users" do
              make_user
              admins.each do |admin|
                expect { admin.reload }.to change(admin, :type).from("Admin").to("User")
              end
            end

            it 'other users are unchanged' do
              make_user
              expect { admin_unchanged.reload }.to_not change(admin_unchanged, :type)
            end

            it 'returns 200 status' do
              make_user
              expect(response).to be_successful
            end
          end
        end

        context 'with invalid attributes' do

          let(:set_invalid_type) { patch :change_type, params: { user: { ids: users.map(&:id), type: "INVALID" } } }

          it 'users are unchanged' do
            set_invalid_type
            users.each do |user|
              expect { user.reload }.to_not change(user_unchanged, :type)
            end
          end

          it 'returns 422 status' do
            set_invalid_type
            expect(response).to be_unprocessable
          end
        end

      end

      context 'by User' do

        let(:user) { create(:user) }
        before { login(user) }

        let!(:users) { (create_list(:user, 2)) }
        before { patch :change_type, params: { users: { ids: users.map(&:id), type: "Admin" } } }

        it 'trying renders index view' do
          expect(response).to redirect_to root_path
          expect(flash[:alert]).to eql("You are not authorized to perform this action.")
        end
      end

    end

    describe "Unauthenticated user" do
      let!(:users) { (create_list(:user, 2)) }
      before { patch :change_type, params: { users: { ids: users.map(&:id), type: "Admin" } } }

      it 'trying renders index view' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
