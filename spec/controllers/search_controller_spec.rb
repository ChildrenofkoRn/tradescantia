require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:params_search) { { query: 'Godsmack', type: 'Love-Hate-Sex-Pain' } }
    let(:params) { { search: params_search } }

    before do
      expect(SearchSphinxService).to receive(:call).with(**params_search)

      get :index, params: params
    end

    it 'returns 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'render index' do
      expect(response).to render_template :index
    end
  end
end
