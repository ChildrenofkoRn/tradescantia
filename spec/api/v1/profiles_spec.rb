require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { ref_headers }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    context 'unauthorized' do
      it_behaves_like 'API Authorizable' do
        let(:action) { :get }
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:token) { create(:api_token, resource_owner_id: me.id).token }

      before do
        get api_path,
            params: { access_token: token },
            headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|

          expect(json).to_not have_key(attr)
        end
      end
    end
  end

end