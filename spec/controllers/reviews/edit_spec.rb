require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  describe "GET #edit" do

    describe "Authenticated user" do
      let(:user) { create(:user) }
      before { login(user) }

      # TODO split context on Link exists/no exists
      context 'by author' do
        let!(:review) { create(:review, author: user) }
        before  { get :edit, params: { id: review } }

        it "assigns the review" do
          expect(assigns(:review)).to eq review
        end

        it "assigns new link" do
          expect(assigns(:review).link).to be_a_new(Link)
        end

        it 'renders edit view' do
          expect(response).to render_template :edit
        end
      end

      context 'by non-author' do
        let!(:another_authors_review) { create(:review) }
        before  { get :edit, params: { id: another_authors_review } }

        it 'redirects to show with flash message' do
          expect(response).to redirect_to root_path
          expect(flash[:alert]).to eql("You are not authorized to perform this action.")
        end
      end
    end

    describe "Unauthenticated user" do
      let!(:review) { create(:review) }
      before  { get :edit, params: { id: review } }

      it 'redirects to login page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

  end
end
