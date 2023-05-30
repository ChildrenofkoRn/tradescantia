require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { ref_headers }

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:action) { :get }
    end

    context 'authorized as User' do
      let!(:users) { create_list(:user, 2) }
      let!(:admin) { create(:admin) }
      let(:user) { users.first }
      let(:token) { create(:api_token, resource_owner_id: user.id).token }
      let(:user_profile) { json.first }

      before do
        get api_path,
            params: { access_token: token },
            headers: headers
      end

      it_behaves_like 'API Successfulable'

      it 'returns a list of users' do
        expect(json.size).to eq users.size
      end

      it 'returns a list doesnt contain admins profiles' do
        admins_proiles = json.select { |profile| profile["attributes"]['type'] == "Admin" }
        expect(admins_proiles).to be_empty
      end

      it_behaves_like 'API Returns fields' do
        let(:object) { user }
        let(:resource) { user_profile }
        let(:public_fields) { %w[username created_at updated_at] }
        let(:private_fields) { %w[password encrypted_password email] }
      end
    end

    context 'authorized as Admin' do
      let!(:users) { create_list(:user, 2) }
      let!(:admin) { create(:admin) }
      let(:token) { create(:api_token, resource_owner_id: admin.id).token }
      let(:user_profile) { json.first }

      before do
        get api_path,
            params: { access_token: token },
            headers: headers
      end

      it_behaves_like 'API Successfulable'

      it 'returns a list of all users' do
        expect(json.size).to eq 3
      end

      it 'returns a list containing admins profiles' do
        admin_profile = json.select { |profile| profile["attributes"]['type'] == "Admin" }.first
        expect(admin_profile["id"]).to eq admin.id.to_json
      end

      it_behaves_like 'API Returns fields' do
        let(:object) { users.first }
        let(:resource) { user_profile }
        let(:public_fields) { %w[username created_at updated_at email] }
        let(:private_fields) { %w[password encrypted_password] }
      end

    end
  end

end
