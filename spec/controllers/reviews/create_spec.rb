require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  describe "POST #create" do

    describe "Authenticated user" do
      let(:user) { create(:user) }
      before { login(user) }

      context 'with valid attributes' do
        let(:attrs_review) { attributes_for(:review) }
        let(:review_create) { post :create, params: { review: attrs_review } }

        it 'saves a new review to DB' do
          expect { review_create }.to change(Review, :count).by(1)
        end

        it 'saves a new review to the logged user' do
          expect { review_create }.to change(user.reviews, :count).by(1)
        end

        it 'save the review with the specified attrs' do
          review_create

          expect(assigns(:review).title).to eq attrs_review[:title]
          expect(assigns(:review).body).to eq attrs_review[:body]
        end

        it 'redirects to show view' do
          expect(review_create).to redirect_to assigns(:review)
        end
      end

      context 'with invalid attributes' do
        let(:review_create) { post :create, params: { review: attributes_for(:review, :invalid) } }

        it 'doesn\'t save the review' do
          expect { review_create }.to_not change(Review, :count)
        end

        it 're-renders new view' do
          expect(review_create).to render_template :new
        end
      end
    end


    describe "Unauthenticated user" do
      context 'with valid attributes' do
        let(:review_create) { post :create, params: { review: attributes_for(:review) } }

        it 'didn\'t saves a new review to DB' do
          expect { review_create }.to_not change(Review, :count)
        end

        it 'redirects to login page' do
          expect(review_create).to redirect_to new_user_session_path
        end
      end
    end

  end
end
