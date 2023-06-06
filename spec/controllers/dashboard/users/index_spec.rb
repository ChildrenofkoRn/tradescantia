require 'rails_helper'

RSpec.describe Dashboard::UsersController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

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
  end

end
