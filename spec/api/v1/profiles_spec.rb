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
        %w[email created_at updated_at].each do |attr|

          expect(json["data"]["attributes"][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|

          expect(json["data"]["attributes"]).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:action) { :get }
    end

    context 'authorized' do
      let(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      let(:token) { create(:api_token, resource_owner_id: user.id).token }
      let(:user_response) { json["data"].first }

      before do
        get api_path,
            params: { access_token: token },
            headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of users' do
        expect(json["data"].size).to eq users.size
      end

      it 'returns all public fields' do
        %w[email created_at updated_at].each do |attr|

          expect(user_response["attributes"][attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|

          expect(user_response["attributes"]).to_not have_key(attr)
        end
      end
    end
  end

end