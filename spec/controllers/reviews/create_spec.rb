require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  describe "POST #create" do

    describe "Authenticated user" do
      let(:user) { create(:user) }
      before { login(user) }

      context 'with valid attributes' do

        context 'for review & link' do
          let(:attrs_link) { attributes_for(:link) }
          let(:attrs_review) { attributes_for(:review, link_attributes: attrs_link) }
          let(:review_create) { post :create, params: { review: attrs_review } }

          it 'saves a new review to DB' do
            expect { review_create }.to change(Review, :count).by(1)
          end

          it 'saves a new link to DB' do
            expect { review_create }.to change(Link, :count).by(1)
          end

          it 'saves a new review to the logged user' do
            expect { review_create }.to change(user.reviews, :count).by(1)
          end

          it 'save the review & link with the specified attrs' do
            review_create

            expect(assigns(:review).title).to eq attrs_review[:title]
            expect(assigns(:review).body).to eq attrs_review[:body]

            expect(assigns(:review).link.title).to eq attrs_link[:title]
            expect(assigns(:review).link.url).to eq attrs_link[:url]
          end

          it 'redirects to show view' do
            expect(review_create).to redirect_to assigns(:review)
          end
        end

        context 'empty link doesn\'t save' do
          let(:attrs_link) { attributes_for(:link, :empty) }
          let(:attrs_review) { attributes_for(:review, link_attributes: attrs_link) }
          let(:review_create) { post :create, params: { review: attrs_review } }

          it 'saves a new review to DB' do
            expect { review_create }.to change(Review, :count).by(1)
          end

          it 'doesn\'t save the link' do
            expect { review_create }.to_not change(Link, :count)
          end

          it 'saves a new review to the logged user' do
            expect { review_create }.to change(user.reviews, :count).by(1)
          end

          it 'save the review & link with the specified attrs' do
            review_create

            expect(assigns(:review).title).to eq attrs_review[:title]
            expect(assigns(:review).body).to eq attrs_review[:body]
          end

          it 'redirects to show view' do
            expect(review_create).to redirect_to assigns(:review)
          end
        end

      end

      context 'with invalid attributes' do
        context 'for review' do
          let(:attrs_link) { attributes_for(:link) }
          let(:attrs_review) { attributes_for(:review, :invalid, link_attributes: attrs_link) }
          let(:review_create) { post :create, params: { review: attrs_review } }

          it 'doesn\'t save the review' do
            expect { review_create }.to_not change(Review, :count)
          end

          it 'doesn\'t save the link' do
            expect { review_create }.to_not change(Link, :count)
          end

          it 're-renders new view' do
            expect(review_create).to render_template :new
          end
        end

        context 'for link' do
          let(:attrs_link) { attributes_for(:link, :invalid) }
          let(:attrs_review) { attributes_for(:review, link_attributes: attrs_link) }
          let(:review_create) { post :create, params: { review: attrs_review } }

          it 'doesn\'t save the review' do
            expect { review_create }.to_not change(Review, :count)
          end

          it 'doesn\'t save the link' do
            expect { review_create }.to_not change(Link, :count)
          end

          it 're-renders new view' do
            expect(review_create).to render_template :new
          end
        end

      end
    end


    describe "Unauthenticated user" do
      context 'with valid attributes' do
        let(:attrs_link) { attributes_for(:link) }
        let(:attrs_review) { attributes_for(:review, link_attributes: attrs_link) }
        let(:review_create) { post :create, params: { review: attrs_review } }

        it 'didn\'t saves a new review to DB' do
          expect { review_create }.to_not change(Review, :count)
        end

        it 'didn\'t saves a new link to DB' do
          expect { review_create }.to_not change(Link, :count)
        end

        it 'redirects to login page' do
          expect(review_create).to redirect_to new_user_session_path
        end
      end
    end

  end
end
