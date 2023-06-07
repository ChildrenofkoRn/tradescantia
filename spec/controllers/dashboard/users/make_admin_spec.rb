require 'rails_helper'

RSpec.describe Dashboard::UsersController, type: :controller do

  describe "Authenticated user" do
    context 'by Admin' do
      let(:admin) { create(:admin) }
      before { login(admin) }

      let!(:users) { (create_list(:user, 2)) }
      let!(:user_unchanged) { (create(:user)) }
      let(:make_admin) { patch :make_admin, params: { user: { ids: users.map(&:id)} } }

      it "update list users" do
        make_admin
        users.each do |user|
          expect { user.reload }.to change(user, :type).from("User").to("Admin")
        end
      end

      it 'other uses are unchanged' do
        make_admin
        expect { user_unchanged.reload }.to_not change(user_unchanged, :type)
      end

      it 'returns 200 status' do
        make_admin
        expect(response).to be_successful
      end
    end

    context 'by User' do

      let(:user) { create(:user) }
      before { login(user) }

      let!(:users) { (create_list(:user, 2)) }
      before { patch :make_admin, params: { users: { ids: users.map(&:id)} } }

      it 'trying renders index view' do
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eql("You are not authorized to perform this action.")
      end
    end

  end

  describe "Unauthenticated user" do
    let!(:users) { (create_list(:user, 2)) }
    before { patch :make_admin, params: { users: { ids: users.map(&:id)} } }

    it 'trying renders index view' do
      expect(response).to redirect_to new_user_session_path
    end
  end

end
