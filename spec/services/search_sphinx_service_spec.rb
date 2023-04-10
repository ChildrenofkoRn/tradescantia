require 'rails_helper'

RSpec.describe SearchSphinxService do
  let!(:user) { create(:user) }
  let!(:review) { create(:review, author: user) }

  it 'search w/o type calls ThinkingSphinx' do
    expect(ThinkingSphinx).to receive(:search).with(review.title)

    described_class.call(search_query: review.title)
  end

  it 'search with not allow type calls ThinkingSphinx' do
    expect(ThinkingSphinx).to receive(:search).with(review.title)

    described_class.call(search_query: review.title)
  end

  SearchSphinxService::ALLOW_TYPES.each_pair do |type, klass|
    it "search by #{type}" do
      expect(klass).to receive(:search).with("Better Days")

      described_class.call(search_query: "Better Days", search_type: type)
    end
  end

  it 'search without search_query return an empty array' do
    params = { search_query: '', search_type: '' }

    expect( described_class.call(**params) ).to match_array([])
  end

end
