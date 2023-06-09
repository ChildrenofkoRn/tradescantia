require 'rails_helper'

describe 'Review API', type: :request do
  let(:headers) { ref_headers }

  describe 'GET /api/v1/reviews/:id' do
    let(:review) { create(:review, :with_link) }
    let(:api_path) { "/api/v1/reviews/#{review.id}" }

    it_behaves_like 'API Authorizable' do
      let(:action) { :get }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:token) { create(:api_token, resource_owner_id: user.id).token }

      before do
        get api_path, params: { access_token: token }, headers: headers
      end

      #TODO repeat for Admin and Author

      it_behaves_like 'API Successfulable'

      it_behaves_like 'API Returns fields' do
        let(:object) { review }
        let(:resource) { json }
        let(:public_fields) { %w[title body created_at updated_at] }
        let(:private_fields) { %w[] }
      end

      describe 'link' do
        it_behaves_like 'API Returns fields' do
          let(:object) { review.link }
          let(:resource) { json("included").first }
          let(:public_fields) { %w[title url created_at updated_at] }
          let(:private_fields) { %w[] }
        end
      end

    end
  end

end
