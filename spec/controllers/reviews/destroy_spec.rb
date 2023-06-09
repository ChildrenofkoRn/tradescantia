require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  describe "DELETE #destroy" do

    describe "Authenticated user" do
      let(:user) { create(:user) }
      before { login(user) }

      context 'by author' do
        let!(:review) { create(:review, :with_link, author: user) }
        let(:review_delete) { delete :destroy, params: { id: review } }

        it "assigns the review" do
          review_delete
          expect(assigns(:review)).to eq review
        end

        it 'delete the review from DB' do
          expect { review_delete }.to change(Review, :count).by(-1)
        end

        it 'delete the link from DB' do
          expect { review_delete }.to change(Link, :count).by(-1)
        end

        it 'renders index view' do
          review_delete
          expect(response).to redirect_to reviews_path
          expect(flash[:notice]).to eql("The review \"#{review.title}\" was successfully deleted.")
        end
      end

      context 'by non-author' do
        let!(:another_authors_review) { create(:review) }
        let(:review_delete) { delete :destroy, params: { id: another_authors_review } }

        it 'didn\'t delete the review from DB' do
          expect { review_delete }.to_not change(Review, :count)
        end

        it 'redirects to show with flash message' do
          expect(review_delete).to redirect_to root_path
          expect(flash[:alert]).to eql("You are not authorized to perform this action.")
        end
      end
    end

    describe "Unauthenticated user" do
      let!(:review) { create(:review) }
      let(:review_delete) { delete :destroy, params: { id: review } }

      it 'didn\'t delete the review from DB' do
        expect { review_delete }.to_not change(Review, :count)
      end

      it 'redirects to login page' do
        review_delete
        expect(response).to redirect_to new_user_session_path
      end
    end

  end
end
