require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  it_behaves_like 'be Modulable', %w[Ranked]

  describe "Authenticated user" do

    let(:user) { create(:user) }
    before { login(user) }

    describe "GET #new" do
      before  { get :new }

      it 'assigns new review' do
        expect(assigns(:review)).to be_a_new(Review)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do

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

    describe "GET #edit" do

      context 'by author' do
        let!(:review) { create(:review, author: user) }
        before  { get :edit, params: { id: review } }

        it "assigns the review" do
          expect(assigns(:review)).to eq review
        end

        it 'renders edit view' do
          expect(response).to render_template :edit
        end

      end

      context 'by non-author' do
        let!(:another_authors_review) { create(:review) }
        before  { get :edit, params: { id: another_authors_review } }

        it 'redirects to show with flash message' do
          expect(response).to redirect_to another_authors_review
          expect(flash[:notice]).to eql("You have no rights to do this.")
        end
      end

    end

    describe "DELETE #destroy" do
      context 'by author' do

        let!(:review) { create(:review, author: user) }
        let(:review_delete) { delete :destroy, params: { id: review } }

        it "assigns the review" do
          review_delete
          expect(assigns(:review)).to eq review
        end

        it 'delete the review from DB' do
          expect { review_delete }.to change(Review, :count).by(-1)
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
          expect(review_delete).to redirect_to another_authors_review
          expect(flash[:notice]).to eql("You have no rights to do this.")
        end
      end

    end

    describe "GET #show" do
      let(:review) { create(:review) }

      before { get :show, params: { id: review } }

      it "assigns the review" do
        expect(assigns(:review)).to eq review
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

    describe "GET #index" do
      let(:reviews) { create_list(:review, 3) }

      before  { get :index }

      it "populates an array of all reviews" do
        expect(assigns(:reviews)).to match_array(reviews)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    describe "PATCH #update" do
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
          expect(review_update).to redirect_to another_authors_review
          expect(flash[:notice]).to eql("You have no rights to do this.")
        end
      end
    end

  end

  describe "Unauthenticated user" do

    describe "PUTCH #ranking" do
        let(:review) { create(:review ) }
        let(:set_rank) { patch :ranking, params: { id: review, rank: 4 }, format: :js }

        it 'response should be js' do
          set_rank
          expect( response.header['Content-Type'] ).to include 'text/javascript'
        end

        it 'doesn\'t save a new rank to DB' do
          expect { set_rank }.to_not change(Rank, :count)
        end

        it 'response status should be 401' do
          set_rank
          expect( response.status ).to eq(401)
        end
    end

    describe "GET #new" do
      before  { get :new }

      it 'redirects to login page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "POST #create" do

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

    describe "GET #edit" do
      let!(:review) { create(:review) }
      before  { get :edit, params: { id: review } }

      it 'redirects to login page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "PATCH #update" do

      let(:init_attr_review) { attributes_for(:review) }
      let(:review_new_attrs) { attributes_for(:review) }
      let!(:another_authors_review) { create(:review, **init_attr_review ) }
      let(:review_update) { patch :update, params: { id: another_authors_review, review: review_new_attrs } }

      it 'didn\'t change the review' do
        review_update
        another_authors_review.reload

        expect(another_authors_review.title).to eq init_attr_review[:title]
        expect(another_authors_review.body).to eq init_attr_review[:body]
      end

      it 'redirects to login page' do
        expect(review_update).to redirect_to new_user_session_path
      end
    end

    describe "DELETE #destroy" do
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

    describe "GET #show" do
      let(:review) { create(:review) }

      before { get :show, params: { id: review } }

      it "assigns the review" do
        expect(assigns(:review)).to eq review
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

    describe "GET #index" do
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
