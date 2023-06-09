shared_examples_for 'API Unprocessable' do

  it 'returns 422 status with errors' do
    expect(response).to be_unprocessable
  end

  it 'returns errors' do
    expect(json("errors")).to_not be_nil
    expect(json).to be_nil
  end
end
