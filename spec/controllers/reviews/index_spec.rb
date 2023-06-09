require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  describe "GET #index" do

    describe "Authenticated user" do
      let(:user) { create(:user) }
      before { login(user) }

      let(:reviews) { create_list(:review, 3) }
      before  { get :index }

      it "populates an array of all reviews" do
        expect(assigns(:reviews)).to match_array(reviews)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end


    describe "Unauthenticated user" do
      let(:reviews) { create_list(:review, 3) }

      before  { get :index }

      it "populates an array of all reviews" do
        expect(assigns(:reviews)).to match_array(reviews)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

  end
end
