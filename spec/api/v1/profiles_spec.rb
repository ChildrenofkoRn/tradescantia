require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT'       => 'application/json' }
  end

  let(:api_path) { '/api/v1/profiles/me' }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get api_path, headers: headers

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get api_path, params: { access_token: 'fc4bdc8be4' }, headers: headers

        expect(response.status).to eq 401
      end
    end

  end

end