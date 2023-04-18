shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(action, api_path, headers: headers)

      expect(response).to be_unauthorized
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(action, api_path, params: { access_token: 'INVALID_TOKEN' }, headers: headers)

      expect(response).to be_unauthorized
    end
  end
end