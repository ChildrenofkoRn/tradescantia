require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  describe "GET #new" do
    describe "Authenticated user" do
      let(:user) { create(:user) }
      before { login(user) }

      before  { get :new }

      it 'assigns new review' do
        expect(assigns(:review)).to be_a_new(Review)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end

    end

    describe "Unauthenticated user" do
      before  { get :new }

      it 'redirects to login page' do
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

end
