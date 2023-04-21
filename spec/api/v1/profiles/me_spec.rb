require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { ref_headers }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:action) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:reviews) { create_list(:review, 2, author: me) }
      let!(:ranks) { create_list(:rank, 2, score: 7, author: me) }
      let(:token) { create(:api_token, resource_owner_id: me.id).token }

      before do
        get api_path,
            params: { access_token: token },
            headers: headers
      end

      it_behaves_like 'API Successfulable'

      it_behaves_like 'API Returns fields' do
        let(:object) { me }
        let(:resource) { json }
        let(:public_fields) { %w[username email created_at updated_at] }
        let(:private_fields) { %w[password encrypted_password] }
      end

      it 'returns reviews_count' do
        expect(json["attributes"]["reviews_count"]).to eq reviews.size.to_s
      end

      it 'returns avarage_rank_given' do
        expect(json["attributes"]["avarage_rank_given"]).to eq ranks.first.score.to_f.to_s
      end

    end
  end

end
