require 'rails_helper'

RSpec.describe 'concern Rankable' do

  with_model :WithRankable do
    table do |t|
    end

    model do
      include Rankable
    end
  end

  let(:user) { create(:user) }
  let!(:rank) { build_stubbed(:rank) }

  it "should have many :ranks" do
    object = WithRankable.create!
    expect(object.ranks.create!(rank.attributes.merge({ author: user}) ).rankable).to eq object
  end

  it "#rank" do
    object = WithRankable.create!
    expect(object.rank).to eq 0

    create_list(:rank, 3, score:7, rankable: object)
    create(:rank, rankable: object, score: 4)

    expect(object.rank).to eq (7 * 3 + 4) / 4.0
  end


  it "#ranks_count" do
    object = WithRankable.create!
    expect(object.rank).to eq 0

    create_list(:rank, 3, rankable: object)
    create(:rank, rankable: object, score: 4)

    expect(object.ranks_count).to eq 4
  end

end
