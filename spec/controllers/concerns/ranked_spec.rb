require 'rails_helper'

class ArtsController < ApplicationController
  before_action :authenticate_user!
end

class ArtPolicy < ApplicationPolicy
end

RSpec.describe Ranked, type: :controller do

  with_model :Art do
    table do |t|
      t.integer :author_id
    end

    model do
      include Rankable
      belongs_to :author, class_name: "User"
    end
  end

  controller ArtsController do
    include Ranked
  end

  before do
    routes.draw { patch :ranking, to: "arts#ranking"}
  end

  describe "PUTCH #ranking" do
    let(:user) { create(:user) }

    describe "Authenticated user" do

      context 'by non-author' do
        let(:author) { create(:user) }
        let(:art) { Art.create!(author: author) }
        before  { login(user) }

        context 'with valid attributes' do

          let(:set_rank) { patch :ranking, params: { id: art.id, rank: 5 }, format: :js }

          it "assigns the review" do
            set_rank
            expect(assigns(:rankable)).to eq art
          end

          it 'saves a new rank to DB' do
            expect { set_rank }.to change(art.ranks, :count).by(1)
          end

          it 'saves a new rank to logged user' do
            expect { set_rank }.to change(user.ranks, :count).by(1)
          end

          it 'response should be javascript' do
            set_rank
            expect( response.header['Content-Type'] ).to include 'text/javascript'
          end

          it 'response status should be 200' do
            set_rank
            expect( response.status ).to eq(200)
          end

          it 'render runking template' do
            expect(set_rank).to render_template "shared/ranked/_ranking"
          end
        end

        context 'with invalid attributes' do
          let(:set_rank) { patch :ranking, params: { id: art, rank: 10 }, format: :js }

          it "assigns the review" do
            set_rank
            expect(assigns(:rankable)).to eq art
          end

          it 'doesn\'t save a new rank to DB' do
            expect { set_rank }.to_not change(art.ranks, :count)
            # expect { set_rank }.to_not change(Rank, :count)
          end

          it 'response should be js' do
            set_rank
            expect( response.header['Content-Type'] ).to include 'text/javascript'
          end

          it 'response status should be 422' do
            set_rank
            expect( response.status ).to eq(422)
          end

          it 'render runking template' do
            expect(set_rank).to render_template "shared/ranked/_ranking"
          end
        end

        context 'already runked' do

          before { patch :ranking, params: { id: art.id, rank: 5 }, format: :js }

          let(:set_rank) { patch :ranking, params: { id: art.id, rank: 7 }, format: :js }

          it "assigns the review" do
            set_rank
            expect(assigns(:rankable)).to eq art
          end

          it 'doesn\'t save a new rank to DB' do
            expect { set_rank }.to_not change(art.ranks, :count)
          end

          it 'response status should be 302' do
            set_rank
            expect( response.status ).to eq(302)
          end

          it 'redirects to root page' do
            expect( set_rank ).to redirect_to root_path
          end

          it 'response contains flash alert from pundit' do
            set_rank
            should set_flash[:alert].to("You are not authorized to perform this action.")
          end
        end

        context 'by author' do
          let(:art) { create(:review, author: user ) }
          let(:own_art) { Art.create!(author: user) }
          let(:set_rank) { patch :ranking, params: { id: own_art, rank: 4 }, format: :js }

          it "assigns the review" do
            set_rank
            expect(assigns(:rankable)).to eq own_art
          end

          it 'doesn\'t save a new rank to DB' do
            expect { set_rank }.to_not change(own_art.ranks, :count)
          end

          it 'response status should be 302' do
            set_rank
            expect( response.status ).to eq(302)
          end

          it 'redirects to root page' do
            expect( set_rank ).to redirect_to root_path
          end

          it 'response contains flash alert from pundit' do
            set_rank
            should set_flash[:alert].to("You are not authorized to perform this action.")
          end
        end

      end
    end

    describe "Unauthenticated user" do

      describe "PUTCH #ranking" do
        let(:art) { Art.create!(author: user) }
        let(:set_rank) { patch :ranking, params: { id: art, rank: 1 }, format: :js }

        it 'doesn\'t save a new rank to DB' do
          expect { set_rank }.to_not change(art.ranks, :count)
        end

        it 'response should be js' do
          set_rank
          expect( response.header['Content-Type'] ).to include 'text/javascript'
        end

        it 'response status should be 401' do
          set_rank
          expect( response.status ).to eq(401)
        end
      end
    end

  end
end
