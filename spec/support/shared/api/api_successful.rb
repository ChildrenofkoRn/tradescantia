shared_examples_for 'API Successfulable' do

  it 'returns 20x status' do
    expect(response).to be_successful
  end
end
