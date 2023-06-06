require 'rails_helper'

RSpec.describe Dashboard::UsersController, type: :controller do

  describe "Authenticated user" do
    context 'by Admin' do
      let(:admin) { create(:admin) }
      before { login(admin) }

      let!(:users) { (create_list(:user, 3) << admin).sort_by { |review| review.created_at }.reverse! }
      before  { get :index }

      it "populates an array of all users" do
        expect(assigns(:users)).to match_array(users)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'by User' do

      let(:user) { create(:user) }
      before { login(user) }

      let(:reviews) { create_list(:review, 3) }
      before  { get :index }

      it 'trying renders index view' do
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eql("You are not authorized to perform this action.")
      end
    end

  end

  describe "Unauthenticated user" do
    let(:reviews) { create_list(:review, 3) }

    before  { get :index }

    it 'trying renders index view' do
      expect(response).to redirect_to new_user_session_path
    end
  end

end
