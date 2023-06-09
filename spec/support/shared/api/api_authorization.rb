shared_examples_for 'API Authorizable' do
  context 'unauthorized' do

    it 'returns 401 status w error message if there is no access_token' do
      do_request(action, api_path, headers: headers)

      expect(response).to be_unauthorized
      expect(json("errors")).to_not be_nil
    end

    it 'returns 401 status w error message if access_token is invalid' do
      do_request(action, api_path, params: { access_token: 'INVALID_TOKEN' }, headers: headers)

      expect(response).to be_unauthorized
      expect(json("errors")).to_not be_nil
    end

  end
end
