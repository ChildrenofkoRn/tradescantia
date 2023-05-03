require 'rails_helper'

RSpec.describe 'concern Rankable' do

  with_model :WithRankable do
    table do |t|
    end

    model do
      include Rankable

      has_one :stat, dependent: :destroy, as: :statable

      after_create ->(art) { art.create_stat }
    end
  end

  let(:user) { create(:user) }
  let!(:rank) { build_stubbed(:rank) }

  it "should have many :ranks" do
    object = WithRankable.create!
    expect(object.ranks.create!(rank.attributes.merge({ author: user}) ).rankable).to eq object
  end

end
