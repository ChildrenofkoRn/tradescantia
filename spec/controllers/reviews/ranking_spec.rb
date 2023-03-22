require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  it_behaves_like 'be Modulable', %w[Ranked]

  describe "PUTCH #ranking" do

    describe "Authenticated user" do
    end

    describe "Unauthenticated user" do
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

  end
end
