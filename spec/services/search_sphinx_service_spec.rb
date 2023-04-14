require 'rails_helper'

RSpec.describe SearchSphinxService do
  let!(:user) { create(:user) }
  let!(:review) { create(:review, author: user) }
  let!(:pagination_opts) { { page: nil, per_page: 10 } }

  it 'search w/o type calls ThinkingSphinx' do
    expect(ThinkingSphinx).to receive(:search).with(review.title, pagination_opts)
                                              .and_return(ThinkingSphinx::Search.new)

    described_class.call(query: review.title)
  end

  it 'search with not allow type calls ThinkingSphinx' do
    expect(ThinkingSphinx).to receive(:search).with(review.title, pagination_opts)
                                              .and_return(ThinkingSphinx::Search.new)

    described_class.call(query: review.title)
  end

  SearchSphinxService::ALLOW_TYPES.each_pair do |type, klass|
    it "search by #{type}" do
      expect(klass).to receive(:search).with("Better Days", pagination_opts)
                                       .and_return(ThinkingSphinx::Search.new)

      described_class.call(query: "Better Days", type: type)
    end
  end

  it 'search without search_query return an empty array' do
    params = { query: '', type: '' }

    expect( described_class.call(**params) ).to match_array([])
  end

end
