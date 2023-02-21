require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

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

    describe "GET #create" do

      context 'with valid attributes' do
        let(:review_create) { post :create, params: { review: attributes_for(:review) } }

        it 'saves a new review to DB' do
          expect { review_create }.to change(Review, :count).by(1)
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

  describe "Unauthenticated user" do

    describe "GET #new" do
      before  { get :new }

      it 'redirects to login page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "GET #create" do

      context 'with valid attributes' do
        let(:review_create) { post :create, params: { review: attributes_for(:review) } }

        it 'didn\'t saves a new post to DB' do
          expect { review_create }.to_not change(Review, :count)
        end

        it 'redirects to login page' do
          expect(review_create).to redirect_to new_user_session_path
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

  end

end
