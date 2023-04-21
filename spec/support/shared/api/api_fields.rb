shared_examples_for 'API Returns fields' do
  it 'returns public fields' do
    public_fields.each do |field|
      expect(resource["attributes"][field]).to eq object.send(field).as_json.to_s
    end

    expect(resource["id"]).to eq object.send("id").to_s
  end

  it 'doesnt return private fields' do
    expect(resource["attributes"]).to_not have_key(private_fields)
  end
end
