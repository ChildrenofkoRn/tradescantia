require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  describe "GET #show" do

    describe "Authenticated user" do
      let(:user) { create(:user) }
      before { login(user) }

      let(:review) { create(:review) }
      before { get :show, params: { id: review } }

      it "assigns the review" do
        expect(assigns(:review)).to eq review
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

    describe "Unauthenticated user" do
      let(:review) { create(:review) }
      before { get :show, params: { id: review } }

      it "assigns the review" do
        expect(assigns(:review)).to eq review
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

  end
end