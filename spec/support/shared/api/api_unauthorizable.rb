shared_examples_for 'API Unauthorizable' do

  it 'returns 401 status' do
    expect(response).to be_unauthorized
  end

  it 'returns errors' do
    expect(json("errors")).to_not be_nil
    expect(json).to be_nil
  end
end
