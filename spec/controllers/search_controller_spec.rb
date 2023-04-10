require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:params_hash) { { search_query: 'Godsmack', search_type: 'Love-Hate-Sex-Pain' } }

    before do
      expect(SearchSphinxService).to receive(:call).with(**params_hash)

      get :index, params: params_hash
    end

    it 'returns 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'render index' do
      expect(response).to render_template :index
    end
  end
end
