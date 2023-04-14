require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  describe "PATCH #update" do

    describe "Authenticated user" do
      let(:user) { create(:user) }
      before { login(user) }

      let(:init_attrs_review) { attributes_for(:review) }
      let(:new_attrs_review) { attributes_for(:review) }

      context 'by author' do
        let!(:review) { create(:review, **init_attrs_review, author: user) }
        let(:review_update) { patch :update, params: { id: review, review: new_attrs_review } }

        context 'with valid attributes' do

          it "assigns the review" do
            review_update
            expect(assigns(:review)).to eq review
          end

          it 'review saved with modified attributes' do
            review_update
            review.reload

            expect(review.title).to eq new_attrs_review[:title]
            expect(review.body).to eq new_attrs_review[:body]
          end

          it 'didn\'t saves a new review to DB' do
            expect { review_update }.to_not change(Review, :count)
          end

          it 'redirects to show view' do
            review_update
            expect(response).to redirect_to review
          end
        end

        context 'with invalid attributes' do
          let(:review_update) { patch :update, params: { id: review, review: attributes_for(:review, :invalid) } }

          it 'didn\'t change the review' do
            review_update
            review.reload

            expect(review.title).to eq init_attrs_review[:title]
            expect(review.body).to eq init_attrs_review[:body]
          end

          it 're-renders edit view' do
            expect(review_update).to render_template :edit
          end
        end
      end

      context 'by non-author' do
        let!(:another_authors_review) { create(:review, **init_attrs_review ) }
        let(:review_update) { patch :update, params: { id: another_authors_review, review: new_attrs_review } }

        it "assigns the review" do
          review_update
          expect(assigns(:review)).to eq another_authors_review
        end

        it 'didn\'t change the review' do
          review_update
          another_authors_review.reload

          expect(another_authors_review.title).to eq init_attrs_review[:title]
          expect(another_authors_review.body).to eq init_attrs_review[:body]
        end

        it 'didn\'t saves a new review to DB' do
          expect { review_update }.to_not change(Review, :count)
        end

        it 'redirects to show with flash message' do
          expect(review_update).to redirect_to root_path
          expect(flash[:alert]).to eql("You are not authorized to perform this action.")
        end
      end
    end

    describe "Unauthenticated user" do
      let(:init_attr_review) { attributes_for(:review) }
      let(:review_new_attrs) { attributes_for(:review) }
      let!(:review) { create(:review, **init_attr_review ) }
      let(:review_update) { patch :update, params: { id: review, review: review_new_attrs } }

      it 'didn\'t change the review' do
        review_update
        review.reload

        expect(review.title).to eq init_attr_review[:title]
        expect(review.body).to eq init_attr_review[:body]
      end

      it 'redirects to login page' do
        expect(review_update).to redirect_to new_user_session_path
      end
    end

  end
end
